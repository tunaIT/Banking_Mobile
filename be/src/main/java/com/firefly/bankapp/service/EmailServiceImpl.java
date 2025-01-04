package com.firefly.bankapp.service;

import java.io.File;

import com.firefly.bankapp.entity.EmailDetails;
import com.firefly.bankapp.service.EmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.experimental.NonFinal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class EmailServiceImpl implements EmailService {
    JavaMailSender javaMailSender;
    @Value("${spring.mail.username}")
    @NonFinal
    String sender;

    @Override
    public void sendSimpleMail(EmailDetails details) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(details.getRecipient());
            message.setFrom(sender);
            message.setSubject(details.getSubject());
            message.setText(details.getMsgBody());
            log.info(sender);
            log.info(details.getMsgBody());
            log.info(details.getRecipient());
            javaMailSender.send(message);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public String sendMailWithAttachment(EmailDetails details) {
        return null;
    }
}
