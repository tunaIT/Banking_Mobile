package matcha.banking.be.controller;

import lombok.RequiredArgsConstructor;
import matcha.banking.be.service.TransitionService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/transition")
public class TransitionController {
    private final TransitionService transitionService;

    @GetMapping("/current")
    public ResponseEntity<Object> searchMyPayment( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok(transitionService.getMyTransition(token.substring(7)));
    }
}
