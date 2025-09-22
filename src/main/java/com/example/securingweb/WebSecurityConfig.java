package com.example.securingweb;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.provisioning.JdbcUserDetailsManager;
import org.springframework.security.provisioning.UserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig {

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		http
				.authorizeHttpRequests((requests) -> requests
						.requestMatchers("/", "/home").permitAll()
						.requestMatchers("/helloAdmin").hasRole("ADMIN")
						.requestMatchers("/hello").hasRole("USER")
						.anyRequest().authenticated()
				)
				.formLogin((form) -> form
						.loginPage("/login")
						.successHandler(customAuthenticationSuccessHandler())
						.permitAll()
				)
				.logout((logout) -> logout.permitAll());

		return http.build();
	}

	// Lấy user từ CSDL
	@Bean
	public UserDetailsManager users(DataSource dataSource) {
		return new JdbcUserDetailsManager(dataSource);
	}

	@Bean
	public AuthenticationSuccessHandler customAuthenticationSuccessHandler() {
		return (request, response, authentication) -> {
			var authorities = authentication.getAuthorities();
			String redirectUrl = "/home";

			if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"))) {
				redirectUrl = "/helloAdmin";
			} else if (authorities.stream().anyMatch(a -> a.getAuthority().equals("ROLE_USER"))) {
				redirectUrl = "/hello";
			}
			response.sendRedirect(redirectUrl);
		};
	}
}
