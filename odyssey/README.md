# Based on the Odyssey project, release 1.3
---


The error below is likekly because of M1 Mac. Will investigate later.

```bash
#0 1.574 [  2%] Building C object sources/CMakeFiles/machine_library_static.dir/thread.c.o
#0 1.676 /test_dir/build-asan/third_party/machinarium/sources/thread.c: In function 'mm_thread_set_name':
#0 1.676 /test_dir/build-asan/third_party/machinarium/sources/thread.c:43:7: warning: implicit declaration of function 'pthread_setname_np' [-Wimplicit-function-declaration]
#0 1.676    43 |  rc = pthread_setname_np(thread->id, name);
#0 1.676       |       ^~~~~~~~~~~~~~~~~~
#0 1.703 [  5%] Building C object sources/CMakeFiles/machine_library_static.dir/pg_rand48.c.o
#0 1.744 [  7%] Building C object sources/CMakeFiles/machine_library_static.dir/lrand48.c.o
#0 1.785 [ 10%] Building C object sources/CMakeFiles/machine_library_static.dir/loop.c.o
#0 1.871 [ 12%] Building C object sources/CMakeFiles/machine_library_static.dir/clock.c.o
#0 1.966 [ 15%] Building C object sources/CMakeFiles/machine_library_static.dir/socket.c.o
#0 2.058 [ 17%] Building C object sources/CMakeFiles/machine_library_static.dir/epoll.c.o
#0 2.146 [ 20%] Building C object sources/CMakeFiles/machine_library_static.dir/context_stack.c.o
#0 2.241 [ 22%] Building C object sources/CMakeFiles/machine_library_static.dir/context.c.o
#0 2.301 /test_dir/build-asan/third_party/machinarium/sources/context.c:68:2: error: #error unsupported architecture
#0 2.301    68 | #error unsupported architecture
#0 2.301       |  ^~~~~
#0 2.308 make[6]: Leaving directory '/test_dir/build-asan/third_party/machinarium'
#0 2.308 make[6]: *** [sources/CMakeFiles/machine_library_static.dir/build.make:167: sources/CMakeFiles/machine_library_static.dir/context.c.o] Error 1
#0 2.308 make[5]: Leaving directory '/test_dir/build-asan/third_party/machinarium'
#0 2.308 make[5]: *** [CMakeFiles/Makefile2:94: sources/CMakeFiles/machine_library_static.dir/all] Error 2
#0 2.309 make[4]: Leaving directory '/test_dir/build-asan/third_party/machinarium'
#0 2.309 make[4]: *** [Makefile:84: all] Error 2
#0 2.309 make[3]: Leaving directory '/test_dir/build-asan'
#0 2.309 make[3]: *** [CMakeFiles/libmachinarium.dir/build.make:64: third_party/machinarium/sources/libmachinarium.a] Error 2
#0 2.310 make[2]: Leaving directory '/test_dir/build-asan'
#0 2.311 make[2]: *** [CMakeFiles/Makefile2:168: CMakeFiles/libmachinarium.dir/all] Error 2
#0 2.311 make[1]: *** [Makefile:84: all] Error 2
#0 2.311 make[1]: Leaving directory '/test_dir/build-asan'
#0 2.312 make: *** [Makefile:47: build_asan] Error 2
------
failed to solve: executor failed running [/bin/sh -c cd /test_dir && make run_test_prep && cp /test_dir/docker/bin/* /usr/bin/]: exit code: 2
```
