package io.roach.data.mybatis;

import java.math.BigDecimal;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.ScheduledExecutorService;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.WebApplicationType;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.context.annotation.*;
import org.springframework.core.Ordered;
import org.springframework.data.jdbc.repository.config.EnableJdbcRepositories;
import org.springframework.data.jdbc.repository.config.MyBatisJdbcConfiguration;
import org.springframework.data.web.config.EnableSpringDataWebSupport;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.config.EnableHypermediaSupport;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

@EnableAutoConfiguration
@EnableHypermediaSupport(type = EnableHypermediaSupport.HypermediaType.HAL)
@EnableAspectJAutoProxy(proxyTargetClass = true)
@EnableJdbcRepositories
@EnableSpringDataWebSupport
@EnableTransactionManagement(order = Ordered.LOWEST_PRECEDENCE - 1)
@Configuration
@ComponentScan
@Import(MyBatisJdbcConfiguration.class)
public class MyBatisApplication implements CommandLineRunner {
    protected static final Logger logger = LoggerFactory.getLogger(MyBatisApplication.class);

    @Autowired
    private DataSource dataSource;

    public static void main(String[] args) {
        new SpringApplicationBuilder(MyBatisApplication.class)
                .web(WebApplicationType.SERVLET)
                .run(args);
    }

    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
        factoryBean.setDataSource(dataSource);
        return factoryBean.getObject();
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
