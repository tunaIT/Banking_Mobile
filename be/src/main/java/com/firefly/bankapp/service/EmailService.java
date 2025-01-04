package com.firefly.bankapp.service;


import com.firefly.bankapp.entity.EmailDetails;

// Interface
public interface EmailService {

    // Method
    // To send a simple email
    void sendSimpleMail(EmailDetails details);

    // Method
    // To send an email with attachment
    String sendMailWithAttachment(EmailDetails details);
}
