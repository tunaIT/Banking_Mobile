//package com.firefly.bankapp.controller;
//
//import com.google.zxing.WriterException;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestHeader;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import java.io.IOException;
//
//@RestController
//@RequestMapping("/qr")
//public class QrController {
//
//    @GetMapping("/generate-qr")
//    public ResponseEntity<byte[]> generateQRCode(@RequestHeader("Authorization") String token) throws WriterException, IOException {
//        // Loại bỏ tiền tố "Bearer " nếu có
//        String jwt = token.startsWith("Bearer ") ? token.substring(7) : token;
//
//        // Lấy thông tin cardNumber từ JWT
//        String cardNumber = jwtUtil.getCardNumberFromJwt(jwt);
//
//        // Tạo nội dung mã QR
//        String qrContent = String.format("CARD:%s", cardNumber);
//        QRCodeWriter qrCodeWriter = new QRCodeWriter();
//        BitMatrix bitMatrix = qrCodeWriter.encode(qrContent, BarcodeFormat.QR_CODE, 300, 300);
//
//        ByteArrayOutputStream pngOutputStream = new ByteArrayOutputStream();
//        MatrixToImageWriter.writeToStream(bitMatrix, "PNG", pngOutputStream);
//
//        byte[] qrCodeImage = pngOutputStream.toByteArray();
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.IMAGE_PNG);
//
//        return ResponseEntity.ok().headers(headers).body(qrCodeImage);
//    }
//
//}
//
