package com.firefly.bankapp.controller;

import com.firefly.bankapp.dto.SearchPaymentDto;
import com.firefly.bankapp.service.PaymentService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/payment")
public class PaymentController {
    private final PaymentService paymentService;

    // done : show toàn bộ payment trong db
    @GetMapping("/search")
    public ResponseEntity<Object> searchPayment(@ModelAttribute SearchPaymentDto searchPaymentDto) {
        return ResponseEntity.ok(paymentService.searchPayment(searchPaymentDto));
    }

    @GetMapping("/current")
    public ResponseEntity<Object> searchMyPayment(@RequestParam(required = false) String category, @RequestHeader("Authorization") String token){
        return ResponseEntity.ok(paymentService.searchMyPayment(category, token.substring(7)));
    }
}