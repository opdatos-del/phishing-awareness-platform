package com.company.phishingawareness.auth;

import java.util.List;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.company.phishingawareness.shared.NotFoundException;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Service
public class UserService {
    private final UserRepository repository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository repository, PasswordEncoder passwordEncoder) {
        this.repository = repository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional(readOnly = true)
    public List<UserResponse> list() {
        return repository.findAll().stream().map(UserResponse::from).toList();
    }

    @Transactional
    public UserResponse create(CreateRequest request) {
        if (repository.existsByUsername(request.username())) throw new IllegalArgumentException("Username already exists: " + request.username());
        User user = new User();
        user.setUsername(request.username());
        user.setPasswordHash(passwordEncoder.encode(request.password()));
        user.setRole(request.role() == null ? User.Role.ANALYST : request.role());
        user.setActive(request.active() == null || request.active());
        return UserResponse.from(repository.save(user));
    }

    @Transactional
    public UserResponse update(Long id, UpdateRequest request) {
        User user = repository.findById(id).orElseThrow(() -> new NotFoundException("User not found with id: " + id));
        if (request.password() != null && !request.password().isBlank()) user.setPasswordHash(passwordEncoder.encode(request.password()));
        if (request.role() != null) user.setRole(request.role());
        if (request.active() != null) user.setActive(request.active());
        return UserResponse.from(repository.save(user));
    }

    public record CreateRequest(@NotBlank @Size(max = 50) String username,
                                @NotBlank @Size(min = 8) String password,
                                User.Role role, Boolean active) {}
    public record UpdateRequest(String password, User.Role role, Boolean active) {}
    public record UserResponse(Long id, String username, User.Role role, Boolean active) {
        static UserResponse from(User user) { return new UserResponse(user.getId(), user.getUsername(), user.getRole(), user.getActive()); }
    }
}
