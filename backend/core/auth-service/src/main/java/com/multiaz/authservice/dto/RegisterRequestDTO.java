package com.multiaz.authservice.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegisterRequestDTO {

  @NotBlank  
  private String name;

  @Email
  @NotBlank
  private String email;

  @NotBlank 
  @Size(min = 8)
  private String password;
  
}
