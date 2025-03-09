<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Profile | Mega City Cabs</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts - Poppins -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        /* Base Styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background-color: #f8f8f8;
            color: #222;
            overflow-x: hidden;
        }

        a {
            text-decoration: none;
            transition: all 0.3s ease;
        }

        /* Navbar Enhancements */
        .navbar {
            transition: all 0.3s ease;
        }

        .navbar-brand {
            transition: transform 0.3s ease;
        }

        .navbar-brand:hover {
            transform: scale(1.05);
        }

        .nav-link {
            position: relative;
            font-weight: 500;
            padding: 8px 15px !important;
            transition: color 0.3s ease;
        }

        .nav-link:after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            background-color: #FFC107;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            transition: width 0.3s ease;
        }

        .nav-link:hover:after {
            width: 80%;
        }

        .btn {
            transition: all 0.3s ease;
            border-radius: 5px;
            font-weight: 500;
        }

        .btn-warning {
            box-shadow: 0 2px 4px rgba(255, 193, 7, 0.4);
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(255, 193, 7, 0.5);
        }

        .btn-outline-dark:hover {
            background-color: #343a40;
            color: white;
            transform: translateY(-2px);
        }

        /* Footer Enhancements */
        .footer-section {
            background: linear-gradient(135deg, #222, #343a40);
        }

        .footer-section a {
            color: #f8f8f8;
            opacity: 0.7;
            transition: all 0.3s ease;
            display: inline-block;
            margin-bottom: 8px;
        }

        .footer-section a:hover {
            color: #FFC107;
            opacity: 1;
            transform: translateX(5px);
        }
    </style>
</head>
<body>
   
    <!-- Main Content -->
    <main class="py-5">
        <div class="container">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-lg-3 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center py-5">
                            <div class="rounded-circle bg-warning d-flex align-items-center justify-content-center mx-auto mb-3" style="width: 120px; height: 120px;">
                                <i class="fas fa-user fa-4x text-white"></i>
                            </div>
                            <h5 class="mb-1">John Doe</h5>
                            <p class="text-muted small mb-3">Member since 2023-05-15</p>
                            <div class="d-grid gap-2">
                                <a href="#" class="btn btn-outline-warning">
                                    <i class="fas fa-edit me-2"></i>Edit Profile
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Main Content -->
                <div class="col-lg-9">
                    <div class="card border-0 shadow-sm mb-4">
                        <div class="card-header bg-white py-3">
                            <h5 class="mb-0">Profile Information</h5>
                        </div>
                        <div class="card-body">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Full Name</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-user text-warning me-2"></i>
                                            John Doe
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Username</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-at text-warning me-2"></i>
                                            JohnDoe123
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Email Address</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-envelope text-warning me-2"></i>
                                            johndoe@example.com
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Phone Number</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-phone text-warning me-2"></i>
                                            +94 76 123 4567
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">NIC Number</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-id-card text-warning me-2"></i>
                                            901234567V
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Member Since</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-calendar text-warning me-2"></i>
                                            2023-05-15
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="mb-3">
                                        <label class="form-label small text-muted">Address</label>
                                        <div class="bg-light p-3 rounded">
                                            <i class="fas fa-map-marker-alt text-warning me-2"></i>
                                            123 Main Street, Colombo 03, Sri Lanka
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>