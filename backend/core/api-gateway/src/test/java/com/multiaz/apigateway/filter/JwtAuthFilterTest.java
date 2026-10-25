package com.multiaz.apigateway.filter;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

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
    private static final String OTHER_ISSUER_SECRET = "FaB4+OIttZanAYOHO2YpSPGcgmLgFHcU+tW0aEkQijQ=";
    private JwtAuthFilter jwtAuthFilter;

    @BeforeEach 
    void setup() {

        jwtAuthFilter = new JwtAuthFilter();
        ReflectionTestUtils.setField(jwtAuthFilter, "jwtSecret", TEST_JWT_SECRET);

    }


    @Test 
    void shouldPassRequestWhenTokenIsSignedByAuthService() throws IOException, ServletException {

        String token = signTokenWith(TEST_JWT_SECRET);

        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/models");

        request.addHeader("Authorization", "Bearer " + token);

        MockHttpServletResponse response = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();
        
        jwtAuthFilter.doFilter(request, response, chain);

        assertEquals(200, response.getStatus());
        assertNotNull(chain.getRequest());
    }

    @Test 
    void shouldFailRequestWhenOtherIssuerSecret() throws IOException, ServletException {

        String token = signTokenWith(OTHER_ISSUER_SECRET);

        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/models");

        request.addHeader("Authorization", "Bearer " + token);

        MockHttpServletResponse response = new MockHttpServletResponse();
        MockFilterChain chain = new MockFilterChain();

        jwtAuthFilter.doFilter(request, response, chain);

        assertEquals(401, response.getStatus());
        assertNull(chain.getRequest());
    }


    // Simula el comportamiento de JwtService del servicio AUTH-SERVICE     
    private String signTokenWith(String secret) {

        SecretKey secretKey =  Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));

        return Jwts.builder()
            .subject("id-user")
            .expiration(new Date(new Date().getTime() + 100000))
            .signWith(secretKey)
            .compact();
        
    }

}
