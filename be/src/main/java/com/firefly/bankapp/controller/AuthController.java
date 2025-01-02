package com.firefly.bankapp.controller;

import com.firefly.bankapp.dto.LoginDto;
import com.firefly.bankapp.dto.LoginReponseBodyDto;
import com.firefly.bankapp.dto.RegisterDto;
import com.firefly.bankapp.entity.UserEntity;
import com.firefly.bankapp.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.http.HttpHeaders;
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

    // Phương thức đăng ký người dùng
    @PostMapping("/register")
    public ResponseEntity<Object> createUser(@RequestBody RegisterDto registerDto) {
        Map<String, Object> responseBody = new HashMap<>();
        try {
            // Gọi phương thức tạo người dùng từ service
            UserEntity userEntity = authService.createUser(registerDto);

            // Tạo URI cho người dùng mới
            URI location = ServletUriComponentsBuilder
                    .fromCurrentRequest()
                    .path("/{email}")
                    .buildAndExpand(registerDto.getEmail())
                    .toUri();

            // Trả về phản hồi 201 Created kèm thông tin người dùng mới
            return ResponseEntity.created(location).body(userEntity);

        } catch (IllegalArgumentException ie) {
            // Xử lý lỗi yêu cầu không hợp lệ (ví dụ: lỗi validation)
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);

        } catch (DuplicateKeyException de) {
            // Xử lý lỗi trùng lặp (ví dụ: người dùng đã tồn tại)
            responseBody.put("error", de.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(responseBody);
        }
    }

    // Phương thức xử lý đăng nhập người dùng
    @PostMapping("/login")
    public ResponseEntity<Object> login(@RequestBody LoginDto loginDto) {
        Map<String, Object> responseBody = new HashMap<>();
        try {
            // Gọi phương thức đăng nhập và lấy token từ service
            LoginReponseBodyDto loginResponse = authService.login(loginDto.getEmail(), loginDto.getPassword());

            // Trả về phản hồi 200 OK kèm token JWT
            return ResponseEntity.ok(loginResponse);

        } catch (IllegalArgumentException ie) {
            // Xử lý lỗi yêu cầu không hợp lệ (ví dụ: thông tin đăng nhập sai)
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);

        } catch (EmptyResultDataAccessException ee) {
            // Xử lý lỗi không tìm thấy người dùng (ví dụ: email sai)
            responseBody.put("error", "Người dùng không tồn tại");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(responseBody);

        } catch (Exception e) {
            // Xử lý bất kỳ lỗi không mong muốn nào khác
            responseBody.put("error", "Đã có lỗi không mong muốn xảy ra");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responseBody);
        }
    }

    // Phương thức tạo mã QR
    @PostMapping("/generate-qr")
    public ResponseEntity<Object> generateQrFromToken(@RequestHeader("Authorization") String token) {
        Map<String, Object> responseBody = new HashMap<>();
        try {
            // Lấy số tài khoản từ token
            String cardNumber = authService.getCardNumberFromToken(token);

            // Tạo mã QR từ số tài khoản
            byte[] qrCode = authService.generateQrCode(cardNumber);

            // Trả về mã QR dưới dạng byte array
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_TYPE, "image/png")
                    .body(qrCode);

        } catch (Exception e) {
            // Xử lý lỗi nếu có
            responseBody.put("error", "Có lỗi xảy ra khi tạo mã QR");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(responseBody);
        }
    }
}
