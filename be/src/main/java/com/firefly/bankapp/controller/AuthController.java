package com.firefly.bankapp.controller;

import com.firefly.bankapp.dto.LoginDto;
import com.firefly.bankapp.dto.LoginReponseBodyDto;
import com.firefly.bankapp.dto.RegisterDto;
import com.firefly.bankapp.entity.UserEntity;
//import com.firefly.bankapp.mapper.UserMapper;
import com.firefly.bankapp.service.AuthService;
//import com.firefly.bankapp.service.EmailService;
//import com.firefly.bankapp.service.UserService;
import lombok.RequiredArgsConstructor;
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
//    private final UserMapper userMapper;
//    private final UserService userService;
//    private final EmailService emailService;

//    @GetMapping("/forgot-pass/{email}")
//    public ResponseEntity<Object> sendPassToMail(@PathVariable String email) {
//        UserEntity userEntity = userService.getUserByEmail(email);
//        Map<String, String> responseBody = new HashMap<>();
//
//
//        if (userEntity == null) {
//            responseBody.put("error", "User not found");
//
//            return ResponseEntity.notFound().build();
//        }
//
//        EmailDetails emailDetails = EmailDetails.builder().recipient(email).msgBody("Your password is: " + userEntity.getPassword()).subject("Matcha Bank").build();
//
//        emailService.sendSimpleMail(emailDetails);
//        responseBody.put("status", "Successfull!!!");
//
//
//        return ResponseEntity.ok(responseBody);
//    }

    // Phương thức xử lý đăng ký người dùng
    @PostMapping("/register")
    public ResponseEntity<Object> createUser(@RequestBody RegisterDto registerDto) {
        // Tạo một đối tượng Map để chứa phản hồi trả về
        Map<String, Object> responseBody = new HashMap<>();
        try {
            // Gọi phương thức tạo người dùng từ lớp `authService` và lưu kết quả vào `userEntity`
            UserEntity userEntity = authService.createUser(registerDto);

            // Tạo URI để phản hồi, từ đường dẫn hiện tại, thêm email của người dùng mới
            URI location = ServletUriComponentsBuilder
                    .fromCurrentRequest()
                    .path("/{email}")
                    .buildAndExpand(registerDto.getEmail())
                    .toUri();

            // Trả về phản hồi 201 (Created) kèm theo thông tin người dùng mới tạo
            return ResponseEntity.created(location).body(userEntity);

        } catch (IllegalArgumentException ie) {
            // Nếu có ngoại lệ `IllegalArgumentException`, trả về lỗi 400 (Bad Request)
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);

        } catch (DuplicateKeyException de) {
            // Nếu có ngoại lệ `DuplicateKeyException`, trả về lỗi 409 (Conflict)
            responseBody.put("error", de.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(responseBody);
        }
    }

    // Phương thức xử lý đăng nhập người dùng
    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody LoginDto loginDto) {
        // Tạo một đối tượng Map để chứa phản hồi trả về
        Map<String, Object> responseBody = new HashMap<>();
        try {
            // Gọi phương thức đăng nhập từ lớp `authService` và lấy token phản hồi
            LoginReponseBodyDto token = authService.login(loginDto.getEmail(), loginDto.getPassword());

            // Trả về phản hồi 200 (OK) kèm theo token nếu đăng nhập thành công
            return ResponseEntity.ok(token);

        } catch (IllegalArgumentException ie) {
            // Nếu có ngoại lệ `IllegalArgumentException`, trả về lỗi 400 (Bad Request)
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);

        } catch (EmptyResultDataAccessException ee) {
            // Nếu không tìm thấy người dùng, trả về lỗi 404 (Not Found)
            responseBody.put("error", ee.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responseBody);
        }
    }
}
