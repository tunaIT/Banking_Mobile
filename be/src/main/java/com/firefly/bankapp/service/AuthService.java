package com.firefly.bankapp.service;

import com.firefly.bankapp.dao.UserDao;
import com.firefly.bankapp.dto.LoginReponseBodyDto;
import com.firefly.bankapp.dto.RegisterDto;
import com.firefly.bankapp.entity.UserEntity;
import com.firefly.bankapp.mapper.UserMapper;
import com.firefly.bankapp.util.JwtUtil;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Service;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

import javax.imageio.ImageIO;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserDao userDao;
    private final JwtUtil jwtUtil;
    private final UserMapper userMapper;

    // Phương thức giải mã token và lấy số tài khoản
    public String getCardNumberFromToken(String token) {
        String jwtToken = token.replace("Bearer ", "");  // Loại bỏ phần "Bearer " khỏi token
        Claims claims = jwtUtil.getClaims(jwtToken);     // Giải mã token và lấy Claims

        // Giả sử số tài khoản được lưu trong claim "cardNumber"
        return claims.get("cardNumber", String.class);
    }

    // Phương thức tạo mã QR từ số tài khoản
    public byte[] generateQrCode(String cardNumber) throws Exception {
        // Tạo mã QR từ số tài khoản
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(cardNumber, BarcodeFormat.QR_CODE, 200, 200, hints);

        // Chuyển đổi BitMatrix thành BufferedImage
        BufferedImage bufferedImage = toBufferedImage(bitMatrix);

        // Chuyển đổi hình ảnh thành byte array
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ImageIO.write(bufferedImage, "PNG", byteArrayOutputStream);
        return byteArrayOutputStream.toByteArray();
    }

    // Phương thức đăng ký người dùng
    public UserEntity createUser(RegisterDto registerDto) {
        String error = inputCheck(registerDto);

        // check if there is any error
        if (!error.isEmpty()) {
            throw new IllegalArgumentException(error);
        }

        if (userDao.findByEmail(registerDto.getEmail()).isPresent()) {
            throw new DuplicateKeyException("Email already exists");
        }

        String cardNumber;
        do {
            cardNumber = generateRandomCardNumber();
        } while (userDao.findByCardNumber(cardNumber).isPresent());

        UserEntity userEntity = new UserEntity();
        userEntity.setName(registerDto.getName());
        userEntity.setEmail(registerDto.getEmail());
        userEntity.setCardNumber(cardNumber);
        userEntity.setBalance(0.0);
        userEntity.setBank("Firefly Bank");
        userEntity.setPassword(registerDto.getPassword());
        userEntity.setCreated(LocalDateTime.now());
        userEntity.setUpdated(LocalDateTime.now());
        return userDao.save(userEntity);
    }

    // Phương thức đăng nhập người dùng
    public LoginReponseBodyDto login(String email, String password) {
        if (email == null || email.isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        } else if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }

        UserEntity userEntity = userDao.findByEmail(email).orElseThrow(
                () -> new EmptyResultDataAccessException("User not found", 1)
        );
        if (userEntity.getPassword().equals(password)) {
            LoginReponseBodyDto loginReponseBodyDto = new LoginReponseBodyDto();
            loginReponseBodyDto.setToken(jwtUtil.generateToken(userEntity));
            loginReponseBodyDto.setUser(userMapper.entityToDto(userEntity));
            return loginReponseBodyDto;
        } else {
            throw new IllegalArgumentException("Invalid password");
        }
    }

    private String generateRandomCardNumber() {
        Random random = new Random();
        StringBuilder cardNumber = new StringBuilder(10);
        for (int i = 0; i < 10; i++) {
            int digit = random.nextInt(10); // generates a random digit from 0 to 9
            cardNumber.append(digit);
        }
        return cardNumber.toString();
    }

    private String inputCheck(RegisterDto registerDto) {
        StringBuilder error = new StringBuilder();
        if (registerDto.getName() == null || registerDto.getName().isEmpty()) {
            error.append("Name is required");
        } else if (registerDto.getPassword() == null || registerDto.getPassword().isEmpty()) {
            error.append("Password is required");
        } else if (registerDto.getEmail() == null || registerDto.getEmail().isEmpty()) {
            error.append("Email is required");
        }
        return error.toString();
    }

    // Phương thức chuyển đổi BitMatrix thành BufferedImage
    public BufferedImage toBufferedImage(BitMatrix matrix) {
        int width = matrix.getWidth();
        int height = matrix.getHeight();
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        image.createGraphics();

        // Điền màu trắng cho nền và màu đen cho mã QR
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                image.setRGB(x, y, matrix.get(x, y) ? Color.BLACK.getRGB() : Color.WHITE.getRGB());
            }
        }
        return image;
    }
}
