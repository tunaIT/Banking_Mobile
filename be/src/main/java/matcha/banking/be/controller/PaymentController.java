package matcha.banking.be.controller;

import lombok.RequiredArgsConstructor;
import matcha.banking.be.dto.SearchPaymentDto;
import matcha.banking.be.service.PaymentService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/payment")
public class PaymentController {
    private final PaymentService paymentService;

    @GetMapping("/search")
    public ResponseEntity<Object> searchPayment(@ModelAttribute SearchPaymentDto searchPaymentDto) {
        return ResponseEntity.ok(paymentService.searchPayment(searchPaymentDto));
    }

    @GetMapping("/current")
    public ResponseEntity<Object> searchMyPayment(@RequestParam(required = false) String category, @RequestHeader("Authorization") String token){
        return ResponseEntity.ok(paymentService.searchMyPayment(category, token.substring(7)));
    }
}
