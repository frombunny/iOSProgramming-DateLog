package com.ios.datelog;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class DatelogApplication {
	public static void main(String[] args) {
		SpringApplication.run(DatelogApplication.class, args);
	}
}
