package com.multiaz.modelregistry;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.multiaz.modelregistry.model.AiModel;
import com.multiaz.modelregistry.repository.AiModelRepository;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

@Disabled("Flapdoodle incompatible con Spring Boot 4.x - requiere MongoDB real")
@SpringBootTest
public class ModelControllerTest {

    private MockMvc mockMvc;

    @Autowired
    private WebApplicationContext context;

    @Autowired
    private AiModelRepository aiModelRepository;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
        aiModelRepository.deleteAll();
    }

    @Test
    void shouldReturnModelById() throws Exception {
        AiModel newModel = AiModel.builder()
                            .name("ranking-universities")
                          .build();
        aiModelRepository.save(newModel);
        mockMvc.perform(get("/models/" + newModel.getId()))
                        .andExpect(status().isOk())
                        .andExpect(jsonPath("$.name").value("ranking-universities"));
    }
}