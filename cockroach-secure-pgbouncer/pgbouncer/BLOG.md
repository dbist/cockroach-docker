# PGBouncer with CockroachDB part 2 (Session vs. Transaction Pooling)

---

I've tested Cockroach with `session` mode primarily. Today, we're going to look at `transaction` pooling.

First the differences in modes:

__Session pooling__

Most polite method. When a client connects, a server connection will be assigned to it for the whole duration it stays connected. When the client disconnects, the server connection will be put back into pool. This mode supports all PostgeSQL features.

__Transaction pooling__

A server connection is assigned to a client only during a transaction. When PgBouncer notices that the transaction is over, the server will be put back into the pool.
This mode breaks a few session-based features of PostgreSQL. You can use it only when the application cooperates by not using features that break. See the [link](https://www.pgbouncer.org/features.html) for incompatible features.

One glaring issue with transaction pooling is inability to run prepared statements. In fact, we have to disable them. For our workload, we do not use any prepared statements but if you consider running apps taking advtantage of prepared statements, this won't be for you.

https://www.pgbouncer.org/faq.html#how-to-use-prepared-statements-with-transaction-pooling
[PGBouncer FAQ](https://www.pgbouncer.org/faq.html)




```bash
docker exec -it client cockroach workload fixtures import tpcc \
 --warehouses=10 'postgresql://roach@pgbouncer:27000/tpcc?sslcert=/shared/client/certs%2Fclient.roach.crt&sslkey=/shared/client/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/shared/client/certs%2Fca.crt'
```

## 10min Session pooling

```bash
docker exec -it client cockroach workload run tpcc \
--warehouses=10 \
--active-warehouses=10 \
--ramp=3m \
--duration=10m \
--workers=100 \
--tolerate-errors \
'postgresql://roach@pgbouncer:27000/tpcc?sslcert=/shared/client/certs%2Fclient.roach.crt&sslkey=/shared/client/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/shared/client/certs%2Fca.crt'
```

```bash
2021-05-24 19:35:11.702 UTC [1] LOG stats: 4 xacts/s, 55 queries/s, in 7999 B/s, out 7045 B/s, xact 37865 us, query 2861 us, wait 0 us
2021-05-24 19:36:11.633 UTC [1] LOG stats: 4 xacts/s, 57 queries/s, in 8659 B/s, out 7585 B/s, xact 36749 us, query 2800 us, wait 0 us
2021-05-24 19:37:11.565 UTC [1] LOG stats: 4 xacts/s, 57 queries/s, in 8806 B/s, out 7723 B/s, xact 37544 us, query 2696 us, wait 0 us
2021-05-24 19:38:11.496 UTC [1] LOG stats: 5 xacts/s, 61 queries/s, in 9172 B/s, out 8039 B/s, xact 39665 us, query 2978 us, wait 0 us
2021-05-24 19:39:11.429 UTC [1] LOG stats: 4 xacts/s, 56 queries/s, in 8116 B/s, out 7065 B/s, xact 39075 us, query 2995 us, wait 0 us
2021-05-24 19:40:11.359 UTC [1] LOG stats: 4 xacts/s, 58 queries/s, in 9029 B/s, out 7922 B/s, xact 38475 us, query 2936 us, wait 0 us
2021-05-24 19:41:11.292 UTC [1] LOG stats: 4 xacts/s, 57 queries/s, in 8578 B/s, out 7615 B/s, xact 37294 us, query 2881 us, wait 0 us
2021-05-24 19:42:11.217 UTC [1] LOG stats: 4 xacts/s, 61 queries/s, in 9155 B/s, out 7978 B/s, xact 37073 us, query 2685 us, wait 0 us
2021-05-24 19:42:32.694 UTC [1] LOG C-0x55edc77f47a0: tpcc/roach@172.23.0.8:51398 closing because: client unexpected eof (age=779s)
2021-05-24 19:42:32.698 UTC [1] LOG C-0x55edc77f4570: tpcc/roach@172.23.0.8:51396 closing because: client unexpected eof (age=779s)
2021-05-24 19:42:32.698 UTC [1] LOG C-0x55edc77f3cb0: tpcc/roach@172.23.0.8:51390 closing because: client unexpected eof (age=779s)
2021-05-24 19:42:32.698 UTC [1] LOG C-0x55edc77f3a80: tpcc/roach@172.23.0.8:51388 closing because: client unexpected eof (age=779s)
```

```bash
_elapsed___errors__ops/sec(inst)___ops/sec(cum)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)
  588.3s        0            1.0            0.2     75.5     75.5     75.5     75.5 delivery
  588.3s        0            1.0            2.0     41.9     41.9     41.9     41.9 newOrder
  588.3s        0            2.0            0.2      8.4      9.4      9.4      9.4 orderStatus
  588.3s        0            0.0            2.1      0.0      0.0      0.0      0.0 payment
  588.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  589.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  589.3s        0            3.0            2.0     54.5     58.7     58.7     58.7 newOrder
  589.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  589.3s        0            3.0            2.1     33.6     46.1     46.1     46.1 payment
  589.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  590.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  590.3s        0            0.0            2.0      0.0      0.0      0.0      0.0 newOrder
  590.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  590.3s        0            4.0            2.1     30.4     35.7     35.7     35.7 payment
  590.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  591.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  591.3s        0            2.0            2.0     48.2     54.5     54.5     54.5 newOrder
  591.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  591.3s        0            0.0            2.1      0.0      0.0      0.0      0.0 payment
  591.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
_elapsed___errors__ops/sec(inst)___ops/sec(cum)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)
  592.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  592.3s        0            0.0            2.0      0.0      0.0      0.0      0.0 newOrder
  592.3s        0            1.0            0.2     11.5     11.5     11.5     11.5 orderStatus
  592.3s        0            1.0            2.1     30.4     30.4     30.4     30.4 payment
  592.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  593.3s        0            1.0            0.2     92.3     92.3     92.3     92.3 delivery
  593.3s        0            1.0            2.0     56.6     56.6     56.6     56.6 newOrder
  593.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  593.3s        0            2.0            2.1     29.4     37.7     37.7     37.7 payment
  593.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  594.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  594.3s        0            1.0            2.0     67.1     67.1     67.1     67.1 newOrder
  594.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  594.3s        0            1.0            2.1     35.7     35.7     35.7     35.7 payment
  594.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  595.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  595.3s        0            1.0            2.0     46.1     46.1     46.1     46.1 newOrder
  595.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  595.3s        0            3.0            2.1     37.7     39.8     39.8     39.8 payment
  595.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
_elapsed___errors__ops/sec(inst)___ops/sec(cum)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)
  596.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  596.3s        0            2.0            2.0     44.0     52.4     52.4     52.4 newOrder
  596.3s        0            1.0            0.2     13.1     13.1     13.1     13.1 orderStatus
  596.3s        0            5.0            2.1     24.1     35.7     35.7     35.7 payment
  596.3s        0            1.0            0.2     12.6     12.6     12.6     12.6 stockLevel
  597.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  597.3s        0            3.0            2.0     52.4     62.9     62.9     62.9 newOrder
  597.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  597.3s        0            2.0            2.1     27.3     44.0     44.0     44.0 payment
  597.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  598.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  598.3s        0            3.0            2.0     48.2     50.3     50.3     50.3 newOrder
  598.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  598.3s        0            1.0            2.1     25.2     25.2     25.2     25.2 payment
  598.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
  599.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
  599.3s        0            2.0            2.0     41.9     60.8     60.8     60.8 newOrder
  599.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
  599.3s        0            1.0            2.1     24.1     24.1     24.1     24.1 payment
  599.3s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
  599.3s        0            123            0.2     79.5     79.7    104.9    184.5    201.3  delivery

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
  599.3s        0           1221            2.0     49.6     46.1     71.3     88.1    302.0  newOrder

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
  599.3s        0            127            0.2     10.8     10.5     16.8     19.9     23.1  orderStatus

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
  599.3s        0           1256            2.1     27.8     26.2     41.9     52.4    104.9  payment

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
  599.3s        0            123            0.2     13.3     12.6     22.0     29.4     30.4  stockLevel

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__result
  599.3s        0           2850            4.8     38.0     37.7     71.3     96.5    302.0
Audit check 9.2.1.7: SKIP: not enough delivery transactions to be statistically significant
Audit check 9.2.2.5.1: SKIP: not enough orders to be statistically significant
Audit check 9.2.2.5.2: SKIP: not enough orders to be statistically significant
Audit check 9.2.2.5.3: SKIP: not enough orders to be statistically significant
Audit check 9.2.2.5.4: SKIP: not enough payments to be statistically significant
Audit check 9.2.2.5.5: SKIP: not enough payments to be statistically significant
Audit check 9.2.2.5.6: SKIP: not enough order status transactions to be statistically significant

_elapsed_______tpmC____efc__avg(ms)__p50(ms)__p90(ms)__p95(ms)__p99(ms)_pMax(ms)
  599.3s      122.2  95.1%     49.6     46.1     65.0     71.3     88.1    302.0
  ```

## 20min session pooling

```bash
docker exec -it client cockroach workload run tpcc \
--warehouses=10 \
--active-warehouses=10 \
--ramp=3m \
--duration=20m \
--workers=100 \
--tolerate-errors \
'postgresql://roach@pgbouncer:27000/tpcc?sslcert=/shared/client/certs%2Fclient.roach.crt&sslkey=/shared/client/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/shared/client/certs%2Fca.crt'
```

```bash
2021-05-24 19:57:10.194 UTC [1] LOG stats: 4 xacts/s, 60 queries/s, in 9269 B/s, out 8192 B/s, xact 39292 us, query 2863 us, wait 0 us
2021-05-24 19:58:10.124 UTC [1] LOG stats: 4 xacts/s, 54 queries/s, in 8530 B/s, out 7487 B/s, xact 42460 us, query 3144 us, wait 0 us
2021-05-24 19:59:10.056 UTC [1] LOG stats: 5 xacts/s, 60 queries/s, in 8843 B/s, out 7742 B/s, xact 37636 us, query 2823 us, wait 0 us
2021-05-24 20:00:09.988 UTC [1] LOG stats: 4 xacts/s, 57 queries/s, in 8198 B/s, out 7213 B/s, xact 36392 us, query 2784 us, wait 0 us
2021-05-24 20:01:09.920 UTC [1] LOG stats: 5 xacts/s, 64 queries/s, in 9693 B/s, out 8540 B/s, xact 38832 us, query 2872 us, wait 0 us
2021-05-24 20:02:09.855 UTC [1] LOG stats: 4 xacts/s, 58 queries/s, in 8327 B/s, out 7227 B/s, xact 37834 us, query 2864 us, wait 0 us
2021-05-24 20:03:46.677 UTC [1] LOG stats: 3 xacts/s, 36 queries/s, in 5457 B/s, out 4819 B/s, xact 44337 us, query 3370 us, wait 0 us
2021-05-24 20:04:46.618 UTC [1] LOG stats: 4 xacts/s, 53 queries/s, in 8172 B/s, out 7038 B/s, xact 43995 us, query 3242 us, wait 0 us
2021-05-24 20:05:46.549 UTC [1] LOG stats: 4 xacts/s, 59 queries/s, in 8946 B/s, out 7853 B/s, xact 168372 us, query 13526 us, wait 0 us
2021-05-24 20:06:46.480 UTC [1] LOG stats: 4 xacts/s, 57 queries/s, in 8798 B/s, out 7656 B/s, xact 38768 us, query 2800 us, wait 0 us
2021-05-24 20:07:46.414 UTC [1] LOG stats: 5 xacts/s, 60 queries/s, in 9213 B/s, out 8106 B/s, xact 37467 us, query 2796 us, wait 0 us
2021-05-24 20:07:49.460 UTC [1] LOG C-0x55edc77f7360: tpcc/roach@172.23.0.8:56834 closing because: client unexpected eof (age=1416s)
2021-05-24 20:07:49.461 UTC [1] LOG C-0x55edc77f6f00: tpcc/roach@172.23.0.8:56832 closing because: client unexpected eof (age=1416s)
2021-05-24 20:07:49.461 UTC [1] LOG C-0x55edc77f6cd0: tpcc/roach@172.23.0.8:56830 closing because: client unexpected eof (age=1416s)
2021-05-24 20:07:49.461 UTC [1] LOG C-0x55edc77f6410: tpcc/roach@172.23.0.8:56828 closing because: client unexpected eof (age=1416s)
2021-05-24 20:07:49.461 UTC [1] LOG C-0x55edc77f5fb0: tpcc/roach@172.23.0.8:56826 closing because: client unexpected eof (age=1416s)
2021-05-24 20:07:49.462 UTC [1] LOG C-0x55edc77f5d80: tpcc/roach@172.23.0.8:56824 closing because: client unexpected eof (age=1416s)
```

```bash
_elapsed___errors__ops/sec(inst)___ops/sec(cum)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)
 1229.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1229.5s        0            2.0            2.0     56.6     67.1     67.1     67.1 newOrder
 1229.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
 1229.5s        0            0.0            2.0      0.0      0.0      0.0      0.0 payment
 1229.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
 1230.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1230.5s        0            1.0            2.0     44.0     44.0     44.0     44.0 newOrder
 1230.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
 1230.5s        0            1.0            2.0     25.2     25.2     25.2     25.2 payment
 1230.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
 1231.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1231.5s        0            2.0            2.0     44.0     52.4     52.4     52.4 newOrder
 1231.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
 1231.5s        0            3.0            2.0     26.2     26.2     26.2     26.2 payment
 1231.5s        0            1.0            0.2     44.0     44.0     44.0     44.0 stockLevel
 1232.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1232.5s        0            4.0            2.0     46.1     65.0     65.0     65.0 newOrder
 1232.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
 1232.5s        0            1.0            2.0     27.3     27.3     27.3     27.3 payment
 1232.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
_elapsed___errors__ops/sec(inst)___ops/sec(cum)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)
 1233.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1233.5s        0            0.0            2.0      0.0      0.0      0.0      0.0 newOrder
 1233.5s        0            1.0            0.2      8.9      8.9      8.9      8.9 orderStatus
 1233.5s        0            2.0            2.0     21.0     31.5     31.5     31.5 payment
 1233.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
 1234.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1234.5s        0            5.0            2.0     46.1     50.3     50.3     50.3 newOrder
 1234.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
 1234.5s        0            1.0            2.0     26.2     26.2     26.2     26.2 payment
 1234.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel
 1235.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 delivery
 1235.5s        0            4.0            2.0     41.9     48.2     48.2     48.2 newOrder
 1235.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 orderStatus
 1235.5s        0            1.0            2.0     19.9     19.9     19.9     19.9 payment
 1235.5s        0            0.0            0.2      0.0      0.0      0.0      0.0 stockLevel

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
 1235.5s        0            253            0.2    102.0     79.7    117.4    234.9   3221.2  delivery

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
 1235.5s        0           2476            2.0     55.9     48.2     75.5    159.4   2818.6  newOrder

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
 1235.5s        0            242            0.2     11.4     10.5     17.8     24.1     54.5  orderStatus

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
 1235.5s        0           2499            2.0     39.0     27.3     46.1    134.2   4563.4  payment

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__total
 1235.5s        0            243            0.2     14.0     12.6     23.1     35.7     44.0  stockLevel

_elapsed___errors_____ops(total)___ops/sec(cum)__avg(ms)__p50(ms)__p95(ms)__p99(ms)_pMax(ms)__result
 1235.5s        0           5713            4.6     46.9     39.8     79.7    151.0   4563.4
Audit check 9.2.1.7: SKIP: not enough delivery transactions to be statistically significant
Audit check 9.2.2.5.1: SKIP: not enough orders to be statistically significant
Audit check 9.2.2.5.2: SKIP: not enough orders to be statistically significant
Audit check 9.2.2.5.3: SKIP: not enough orders to be statistically significant
Audit check 9.2.2.5.4: SKIP: not enough payments to be statistically significant
Audit check 9.2.2.5.5: SKIP: not enough payments to be statistically significant
Audit check 9.2.2.5.6: SKIP: not enough order status transactions to be statistically significant

_elapsed_______tpmC____efc__avg(ms)__p50(ms)__p90(ms)__p95(ms)__p99(ms)_pMax(ms)
 1235.5s      120.2  93.5%     55.9     48.2     67.1     75.5    159.4   2818.6
```


## 10min Transaction pooling

Due to the lack of prepared statement support, we have to leverage non-pgbounced connection to import the tpcc workload.

```bash
docker exec -it client cockroach workload fixtures import tpcc \
 --warehouses=10 'postgresql://roach@lb:26257/tpcc?sslcert=/certs%2Fclient.roach.crt&sslkey=/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/certs%2Fca.crt'
 ```

21.1 introduces a new flag `--method` for tpcc to disable prepared statements

```bash
docker exec -it client cockroach workload run tpcc \
--warehouses=10 \
--active-warehouses=10 \
--ramp=3m \
--duration=10m \
--workers=100 \
--tolerate-errors \
--method=simple \
'postgresql://roach@pgbouncer:27000/tpcc?sslcert=/shared/client/certs%2Fclient.roach.crt&sslkey=/shared/client/certs%2Fclient.roach.key&sslmode=verify-full&sslrootcert=/shared/client/certs%2Fca.crt'
```
