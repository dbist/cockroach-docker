package io.roach.data.jpa;

import java.math.BigDecimal;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ScheduledExecutorService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.config.EnableHypermediaSupport;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

@EnableHypermediaSupport(type = EnableHypermediaSupport.HypermediaType.HAL)
@EnableJpaRepositories
@EnableAspectJAutoProxy(proxyTargetClass = true)
@EnableTransactionManagement
@SpringBootApplication
public class JpaApplication implements CommandLineRunner {
    protected static final Logger logger = LoggerFactory.getLogger(JpaApplication.class);

    public static void main(String[] args) {
        new SpringApplicationBuilder(JpaApplication.class)
                .web(WebApplicationType.SERVLET)
                .run(args);
    }

    @Override
    public void run(String... args) throws Exception {
        logger.info("Lets move some $$ around!");

        final Link transferLink = new Link("http://localhost:8080/transfer{?fromId,toId,amount}");

        final int threads = Runtime.getRuntime().availableProcessors();

        final ScheduledExecutorService executorService = Executors.newScheduledThreadPool(threads);

        Deque<Future<?>> futures = new ArrayDeque<>();

        for (int i = 0; i < threads; i++) {
            Future<?> future = executorService.submit(() -> {
                for (int j = 0; j < 100; j++) {
                    int fromId = 1 + (int) Math.round(Math.random() * 3);
                    int toId = fromId % 4 + 1;

                    BigDecimal amount = new BigDecimal("10.00");

                    Map<String, Object> form = new HashMap<>();
                    form.put("fromId", fromId);
                    form.put("toId", toId);
                    form.put("amount", amount);

                    String uri = transferLink.expand(form).getHref();

                    try {
                        new RestTemplate().exchange(uri, HttpMethod.POST, new HttpEntity<>(null), String.class);
                    } catch (HttpClientErrorException.BadRequest e) {
                        logger.warn(e.getResponseBodyAsString());
                    }
                }
            });
            futures.add(future);
        }

        while (!futures.isEmpty()) {
            try {
                futures.pop().get();
                logger.info("Worker finished - {} remaining", futures.size());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            } catch (ExecutionException e) {
                logger.warn("Worker failed", e.getCause());
            }
        }

        logger.info("All client workers finished but server keeps running. Have a nice day!");

        executorService.shutdownNow();
    }
}
