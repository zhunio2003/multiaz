package com.multiaz.apigateway.filter;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import java.io.IOException;
import java.util.Date;

import javax.crypto.SecretKey;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.test.util.ReflectionTestUtils;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.ServletException;

class JwtAuthFilterTest {

    private static final String TEST_JWT_SECRET = "OxkqedAv+B5woSU8ydR14NlkbxvtJyER1WbGOw2MAXA=";
    private JwtAuthFilter jwtAuthFilter;

    @BeforeEach 
    void setup() {
        jwtAuthFilter = new JwtAuthFilter();

        ReflectionTestUtils.setField(jwtAuthFilter, "jwtSecret", TEST_JWT_SECRET);
    }


    // Simula el comportamiento de JwtService del servicio AUTH-SERVICE 
    @Test 
    void shouldPassRequestWhenTokenIsSignedByAuthService() throws IOException, ServletException {

        SecretKey secretKey =  Keys.hmacShaKeyFor(Decoders.BASE64.decode(TEST_JWT_SECRET));

        String token = Jwts.builder()
            .subject("id-user")
            .expiration(new Date(new Date().getTime() + 100000))
            .signWith(secretKey)
            .compact();


        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/models");

        request.addHeader("Authorization", "Bearer " + token);

        MockHttpServletResponse response = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();
        
        jwtAuthFilter.doFilter(request, response, chain);

        assertEquals(200, response.getStatus());
        assertNotNull(chain.getRequest());
    }

}
