package com.firefly.bankapp.controller;

import com.firefly.bankapp.service.TransitionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/transition")
public class TransitionController {
    private final TransitionService transitionService;

    // done : show giao dich cua user current
    @GetMapping("/current")
    public ResponseEntity<Object> searchMyPayment( @RequestHeader("Authorization") String token){
        return ResponseEntity.ok(transitionService.getMyTransition(token.substring(7)));
    }
}