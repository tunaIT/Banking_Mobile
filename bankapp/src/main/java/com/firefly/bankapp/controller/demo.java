package com.firefly.bankapp.controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController()
public class demo {
    @GetMapping("/")
    public String say(){
         return "Hello";
    }
}
