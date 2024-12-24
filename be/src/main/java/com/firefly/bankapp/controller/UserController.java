package com.firefly.bankapp.controller;

import com.firefly.bankapp.dto.GetUserInfoDto;
import com.firefly.bankapp.dto.RegisterDto;
import com.firefly.bankapp.dto.TransitionDto;
import com.firefly.bankapp.entity.UserEntity;
import com.firefly.bankapp.mapper.UserMapper;
import com.firefly.bankapp.service.TransitionService;
import com.firefly.bankapp.service.UserService;
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
@RequestMapping("/user")
public class UserController {
    private final UserService userService;
    private final TransitionService transitionService;
    private final UserMapper userMapper;


    @PostMapping
    public ResponseEntity<Object> createUser(@RequestBody RegisterDto registerDto) {
        Map<String, Object> responseBody = new HashMap<>();
        try {

            UserEntity userEntity = userService.createUser(registerDto);

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



    @GetMapping("/{card}")
    public ResponseEntity<Object> getUserByCard(@PathVariable String card) {
        UserEntity userEntity = userService.getUserByCard(card);
        if (userEntity == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(userMapper.entityToDto(userEntity));
    }

    // done : chuyển tiền từ tk này sang tk khác
    @PostMapping("/tranfer")
    public ResponseEntity<Object> transfer(@RequestBody TransitionDto transitionDto, @RequestHeader("Authorization") String token) {
        Map<String, Object> responseBody = new HashMap<>();
        try {
            String currentCardNumber = userService.getCardNumberfromToken(token.substring(7));
            transitionDto.setSender(currentCardNumber);
            transitionService.performTransfer(transitionDto);
            return ResponseEntity.ok().build();
        } catch (IllegalArgumentException ie) {
            responseBody.put("error", ie.getMessage());
            return ResponseEntity.badRequest().body(responseBody);
        } catch (DuplicateKeyException de) {
            responseBody.put("error", de.getMessage());
            return ResponseEntity.status(HttpStatus.CONFLICT).body(responseBody);
        }
    }

    // Phương thức lấy thông tin người dùng hiện tại
    @GetMapping("/current-user")
    public ResponseEntity<Object> getCurrentUser(@RequestHeader("Authorization") String token) {
        // Tạo một đối tượng Map để chứa phản hồi trả về
        Map<String, Object> responseBody = new HashMap<>();
        try {
            // Lấy email từ token bằng cách loại bỏ tiền tố "Bearer "
            String email = userService.getEmailfromToken(token.substring(7));

            // Lấy thông tin người dùng từ email
            UserEntity userEntity = userService.getUserByEmail(email);
            System.out.println(userEntity); // In ra thông tin người dùng (chỉ để kiểm tra, có thể xóa trong sản phẩm)

            // Chuyển đổi `UserEntity` sang `GetUserInfoDto` bằng cách sử dụng `userMapper`
            GetUserInfoDto getUserInfoDto = userMapper.entityToDto(userEntity);

            // Trả về phản hồi 200 (OK) kèm theo thông tin người dùng
            return ResponseEntity.ok(getUserInfoDto);

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