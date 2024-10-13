package com.firefly.bankapp.config;

import com.firefly.bankapp.filter.JwtRequestFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@EnableWebSecurity // Bật tính năng bảo mật web của Spring Security.
@Configuration // Đánh dấu lớp này như một lớp cấu hình Spring.
@RequiredArgsConstructor // Tạo constructor với các tham số là các trường final hoặc được đánh dấu @NonNull.
// Trong trường hợp này, nó sẽ tạo constructor cho JwtRequestFilter.
public class SecurityConfigurer {

    // JwtRequestFilter là lớp tùy chỉnh để xử lý JWT.
    private final JwtRequestFilter jwtRequestFilter;

    @Bean
    // SecurityFilterChain filterChain(HttpSecurity http) Định nghĩa chuỗi các bộ lọc bảo mật.
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception{

        // csrf(AbstractHttpConfigurer::disable): Tắt CSRF protection.
        // Thường được tắt khi sử dụng token-based authentication như JWT.
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(  // authorizeHttpRequests: Thiết lập quyền truy cập cho các đường dẫn
                        auth -> auth
                                // requestMatchers("/auth/**").permitAll(): Cho phép tất cả các yêu cầu đến
                                // các đường dẫn bắt đầu bằng /auth/ không cần xác thực.
                                .requestMatchers("/auth/**").permitAll()
                                // anyRequest().authenticated(): Yêu cầu tất cả các yêu cầu khác phải được xác thực.
                                .anyRequest().authenticated()
                )
                // Thiết lập chế độ quản lý phiên làm việc không trạng thái (stateless).
                // Điều này phù hợp với việc sử dụng JWT vì không cần lưu trữ trạng thái phiên trên server.
                .sessionManagement(sess ->
                        sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

                // cors(Customizer.withDefaults()): Bật CORS với cấu hình mặc định. CORS (Cross-Origin Resource Sharing)
                // cho phép ứng dụng chấp nhận các yêu cầu từ các nguồn khác.
                .cors(Customizer.withDefaults())
                // addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class):
                // Thêm JwtRequestFilter
                // vào trước UsernamePasswordAuthenticationFilter trong chuỗi bộ lọc bảo mật.
                // Điều này đảm bảo rằng JWT được xử lý trước khi xác thực người dùng.
                .addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception{
        return configuration.getAuthenticationManager();
    }

}
