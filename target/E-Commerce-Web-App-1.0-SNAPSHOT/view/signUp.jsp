<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apex - Sign Up</title>
    <link rel="icon" type="image/x-icon" href="../assets/a.svg">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../styles/signUp.css">
    <style>
        .password-strength {
            margin-top: 0.25rem;
            font-size: 0.875rem;
        }
        .required:after {
            content: " *";
            color: red;
        }
        .spinner-border {
            width: 1rem;
            height: 1rem;
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
<div class="app-container">
    <!-- Window Controls -->
<%--    <div class="window-controls">--%>
<%--        <div class="window-dot dot-red"></div>--%>
<%--        <div class="window-dot dot-yellow"></div>--%>
<%--        <div class="window-dot dot-green"></div>--%>
<%--    </div>--%>

    <!-- Brand Logo -->
    <a href="../index.jsp" class="brand-logo">
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
            <img src="../assets/logo/mylogo.png" alt="logo" width="32" height="32">
        </svg>
        <span class="logo-text">Apex</span>
    </a>

    <div class="content">
        <!-- Steps -->
        <div class="steps-container">
            <div class="steps-group">
                <div class="step-item step-active">
                    <div class="step-circle">1</div>
                    <div class="step-content">
                        <div class="step-title">Account Details</div>
                        <div class="step-description">Fill in your info</div>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-circle">2</div>
                    <div class="step-content">
                        <div class="step-title">Verification</div>
                        <div class="step-description">Verify email</div>
                    </div>
                </div>
                <div class="step-item">
                    <div class="step-circle">3</div>
                    <div class="step-content">
                        <div class="step-title">Complete</div>
                        <div class="step-description">Ready to shop</div>
                    </div>
                </div>
            </div>
            <div class="signin-link" style="font-size: 14px; color: #6B7280;">
                Already have an account?
                <a href="../index.jsp" style="color: #2563EB; text-decoration: none; font-weight: 500;">Sign in</a>
            </div>
        </div>

        <!-- Form Container -->
        <div class="form-container">
            <div class="form-header">
                <h1 class="form-title">Create an account</h1>
                <p class="form-subtitle">Join Apex today</p>
            </div>

            <form id="registrationForm" action="<%=request.getContextPath()%>/register" method="post">
                <div class="input-group">
                    <div class="row">
                        <div class="col-md-6">
                            <label class="input-label required">First Name</label>
                            <input type="text" name="firstName" class="form-input" placeholder="Enter your first name" required>
                        </div>
                        <div class="col-md-6">
                            <label class="input-label required">Last Name</label>
                            <input type="text" name="lastName" class="form-input" placeholder="Enter your last name" required>
                        </div>
                    </div>

                    <div>
                        <label class="input-label required">Email</label>
                        <input type="email" name="email" class="form-input" placeholder="Enter your email" required>
                    </div>

                    <div>
                        <label class="input-label required">Username</label>
                        <input type="text" name="username" class="form-input" placeholder="Choose a username" required>
                    </div>

                    <div>
                        <label class="input-label required">Password</label>
                        <input type="password" name="password" class="form-input" placeholder="••••••••" required>
                        <div class="password-strength"></div>
                    </div>

                    <div>
                        <label class="input-label required">Confirm Password</label>
                        <input type="password" name="confirmPassword" class="form-input" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 mt-4" id="submitBtn">Create Account</button>
            </form>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <span>© Apex @ Copy Right Reserved</span>
        <span>help@apex.com</span>
<%--        <div class="dots">--%>
<%--            <div class="dot active"></div>--%>
<%--            <div class="dot"></div>--%>
<%--            <div class="dot"></div>--%>
<%--        </div>--%>
    </div>
</div>

<!-- Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.7.32/dist/sweetalert2.all.min.js"></script>

<script>
    $(document).ready(function() {
        $('#registrationForm').on('submit', function(e) {
            e.preventDefault();

            // Show loading state
            const submitBtn = $('#submitBtn');
            const originalBtnText = submitBtn.html();
            submitBtn.prop('disabled', true);
            submitBtn.html('<span class="spinner-border spinner-border-sm"></span>Creating Account...');

            $.ajax({
                url: $(this).attr('action'),
                type: 'POST',
                data: $(this).serialize(),
                dataType: 'json',
                success: function(response) {
                    if (response.status === 'success') {
                        Swal.fire({
                            title: 'Success!',
                            text: 'Registration successful! Redirecting to login...',
                            icon: 'success',
                            timer: 2000,
                            showConfirmButton: false
                        }).then(() => {
                            window.location.href = '../index.jsp';
                        });
                    } else {
                        Swal.fire({
                            title: 'Error!',
                            text: response.message,
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                        submitBtn.prop('disabled', false);
                        submitBtn.html(originalBtnText);
                    }
                },
                error: function(xhr, status, error) {
                    Swal.fire({
                        title: 'Error!',
                        text: 'Something went wrong. Please try again.',
                        icon: 'error',
                        confirmButtonText: 'OK'
                    });
                    submitBtn.prop('disabled', false);
                    submitBtn.html(originalBtnText);
                }
            });
        });

        // Password strength indicator
        $('input[name="password"]').on('input', function() {
            const password = $(this).val();
            let strength = 0;

            if (password.length >= 8) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^A-Za-z0-9]/)) strength++;

            const strengthTexts = ['Weak', 'Fair', 'Good', 'Excellent'];
            const strengthColors = ['#dc3545', '#ffc107', '#198754', '#0dcaf0'];

            if (password.length > 0) {
                $('.password-strength').html(`Password Strength: <span style="color: ${strengthColors[strength - 1]}">${strengthTexts[strength - 1] || 'Very Weak'}</span>`);
            } else {
                $('.password-strength').html('');
            }
        });
    });
</script>

</body>
</html>