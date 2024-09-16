package matcha.banking.be.controller;

import lombok.RequiredArgsConstructor;
import matcha.banking.be.dto.GetUserInfoDto;
import matcha.banking.be.dto.LoginDto;
import matcha.banking.be.dto.LoginReponseBodyDto;
import matcha.banking.be.dto.RegisterDto;
import matcha.banking.be.entity.EmailDetails;
import matcha.banking.be.entity.UserEntity;
import matcha.banking.be.mapper.UserMapper;
import matcha.banking.be.service.AuthService;
import matcha.banking.be.service.EmailService;
import matcha.banking.be.service.UserService;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/auth")
public class AuthController {

    private final AuthService authService;
    private final UserMapper userMapper;
    private final UserService userService;
    private final EmailService emailService;

    @GetMapping("/forgot-pass/{email}")
    public ResponseEntity<Object> sendPassToMail(@PathVariable String email) {
        UserEntity userEntity = userService.getUserByEmail(email);
        Map<String, String> responseBody = new HashMap<>();


        if (userEntity == null) {
            responseBody.put("error", "User not found");

            return ResponseEntity.notFound().build();
        }

        EmailDetails emailDetails = EmailDetails.builder().recipient(email).msgBody("Your password is: " + userEntity.getPassword()).subject("Matcha Bank").build();

        emailService.sendSimpleMail(emailDetails);
        responseBody.put("status", "Successfull!!!");


        return ResponseEntity.ok(responseBody);
    }

    @PostMapping("/register")
    public ResponseEntity<Object> createUser(@RequestBody RegisterDto registerDto) {
        Map<String, Object> responseBody = new HashMap<>();
        try {

            UserEntity userEntity = authService.createUser(registerDto);

            URI location = ServletUriComponentsBuilder
                    .fromCurrentRequest()
                    .path("/{email}")
                    .buildAndExpand(registerDto.getEmail())
                    .toUri();

            return ResponseEntity.created(location).body(userEntity);
        } catch (IllegalArgumentException ie) {
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);
        } catch (DuplicateKeyException de) {
            responseBody.put("error", de.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(responseBody);
        }
    }

    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody LoginDto loginDto) {
        Map<String, Object> responseBody = new HashMap<>();
        try {
            LoginReponseBodyDto token = authService.login(loginDto.getEmail(), loginDto.getPassword());
            return ResponseEntity.ok(token);
        } catch (IllegalArgumentException ie) {
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);
        } catch (EmptyResultDataAccessException ee) {
            responseBody.put("error", ee.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responseBody);
        }
    }
}
