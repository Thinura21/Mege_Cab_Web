<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Retrieve the current session if available
    HttpSession hhtpsession = request.getSession(false);
    String username = "";
    String role = "";
    if (session != null) {
        username = (String) hhtpsession.getAttribute("username");
        role = (String) hhtpsession.getAttribute("role");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Mega City Cab - Colombo's Best Cab Service</title>

    <!-- Include CDN-based CSS and fonts -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    <!-- Link to your custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/styles.css">
</head>
<body>
    <!-- Top Announcement Bar -->
    <div class="top-header py-2 bg-warning text-dark">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <i class="fas fa-phone-alt me-2"></i> Call for Instant Booking: (+94) 11-723-7232
                </div>
                <% if (username != null && !username.isEmpty()) { %>
                        <div class="nav-item d-flex align-items-center">
                            <span class="me-2">Welcome, <strong><%= username %></strong></span>
                        </div>
                    <% } %>
                <div>
                    <a href="https://www.facebook.com" class="text-dark me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="https://x.com" class="text-dark me-3"><i class="fab fa-x-twitter"></i></a>
                    <a href="https://www.instagram.com" class="text-dark me-3"><i class="fab fa-instagram"></i></a>
                </div>
            </div>
        </div>
    </div>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand fw-bold fs-3 text-warning" href="index.jsp"><i class="fa-solid fa-taxi me-2"></i> Mega City Cab</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link active" href="index.jsp"><i class="fas fa-home me-1"></i> Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="#about"><i class="fas fa-info-circle me-1"></i> About Us</a></li>
                    <li class="nav-item"><a class="nav-link" href="#services"><i class="fas fa-taxi me-1"></i> Services</a></li>
					    <% if (role != null) { 
					         if(role.equalsIgnoreCase("Customer")) { %>
					            <a class="nav-link" href="<%= request.getContextPath() %>/BookingServlet">
					                <i class="fas fa-calendar-check me-1"></i> Booking
					            </a>
							    <%   } else if(role.equalsIgnoreCase("Driver")) { %>
							            <a class="nav-link" href="<%= request.getContextPath() %>/manageDriverBooking">
							                <i class="fas fa-calendar-check me-1"></i> Booking
							            </a>
							    <%   } else { %>
							            <a class="nav-link" href="bookingForm.jsp">
							                <i class="fas fa-calendar-check me-1"></i> Booking
							            </a>
							    <%   }
						       } else { %>
						           <a class="nav-link" href="bookingForm.jsp">
						                <i class="fas fa-calendar-check me-1"></i> Booking
						           </a>
						    <% } %>
                    <li class="nav-item"><a class="nav-link" href="#contact"><i class="fas fa-envelope me-1"></i> Contact</a></li>
                </ul>
                <div class="d-flex">
                    <% if (username != null && !username.isEmpty()) { %>
                        <form action="<%= request.getContextPath() %>/logoutServlet" method="post" class="d-inline">
						    <button type="submit" class="btn btn-danger">
						        <i class="bi bi-box-arrow-right me-2"></i>Logout
						    </button>
						</form>

                    <% } else { %>
                        <a href="login.jsp" class="btn btn-warning text-dark"><i class="fas fa-sign-in-alt me-1"></i> Login</a>
                    <% } %>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section id="home" class="hero-section d-flex align-items-center position-relative">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 text-content">
                    <h1 class="fw-bold display-5">Your Trusted Ride in Colombo</h1>
                    <p class="fs-5">
                        Mega City Cab provides safe, fast, and affordable taxi services. 
                        With our new digital booking system, you can schedule your ride in 
                        seconds, track your driver, and enjoy a hassle-free journey.
                    </p>
                    
                    <div class="d-flex align-items-center mb-4">
                        <div class="d-flex">
                            <div class="me-2">
                                <div class="bg-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px">
                                    <i class="fas fa-stopwatch fa-lg"></i>
                                </div>
                            </div>
                            <div>
                                <h6 class="mb-0 fw-bold">Quick Booking</h6>
                                <p class="mb-0 small">Book in under 30 seconds</p>
                            </div>
                        </div>
                        <div class="d-flex ms-4">
                            <div class="me-2">
                                <div class="bg-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 48px; height: 48px">
                                    <i class="fas fa-shield-alt fa-lg"></i>
                                </div>
                            </div>
                            <div>
                                <h6 class="mb-0 fw-bold">Safe Rides</h6>
                                <p class="mb-0 small">Verified drivers & tracking</p>
                            </div>
                        </div>
                    </div>

                    <div class="ride-form">
                        <div class="card shadow-sm p-3 mb-3">
                            <div class="row">
                                <div class="col-md-5 mb-2 mb-md-0">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="fas fa-map-marker-alt text-warning"></i></span>
                                        <input type="text" class="form-control border-0 bg-light" placeholder="Your location">
                                    </div>
                                </div>
                                <div class="col-md-5 mb-2 mb-md-0">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i class="fas fa-map-pin text-warning"></i></span>
                                        <input type="text" class="form-control border-0 bg-light" placeholder="Destination">
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <button class="btn btn-dark w-100">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <button class="btn btn-dark w-100 btn-lg rounded-pill">
                            Find A Taxi <i class="fa-solid fa-arrow-right"></i>
                        </button>
                    </div>
                </div>

                <!-- Image Section -->
                <div class="col-lg-6 text-center position-relative">
                    <img src="<%= request.getContextPath() %>/Assets/Images/cab.png" class="hero-image img-fluid" alt="Mega City Cab Illustration">
                </div>
            </div>
        </div>
    </section>

	<!-- Newsletter Subscription Section -->
	<section class="py-3">
	  <div class="container">
	    <div class="row justify-content-center">
	      <div class="col-lg-10">
	        <div class="bg-dark rounded-4 p-4 text-white">
	          <div class="row align-items-center">
	            <div class="col-md-7">
	              <h4 class="fw-bold">Stay Updated with Our Newsletter</h4>
	              <p class="mb-0">Get exclusive offers, travel tips, and the latest news directly in your inbox!</p>
	            </div>
	            <div class="col-md-5 text-md-end mt-3 mt-md-0">
	              <form class="d-flex flex-column flex-md-row">
	                <input type="email" class="form-control me-md-2 mb-2 mb-md-0" placeholder="Your email address">
	                <button type="submit" class="btn btn-primary">Subscribe</button>
	              </form>
	            </div>
	          </div>
	        </div>
	      </div>
	    </div>
	  </div>
	</section>

    <!-- Why Choose Us Section -->
    <section id="about" class="container my-5 py-4">
        <div class="row align-items-center">
            <div class="col-lg-5 text-center mb-4 mb-lg-0">
                <div class="position-relative">
                    <img src="<%= request.getContextPath() %>/Assets/Images/taxi-service.png" class="img-fluid" alt="Mega City Cab">
                    <div class="position-absolute start-0 bottom-0 bg-warning text-dark p-3 rounded-3 shadow-sm" style="transform: translate(-15%, 15%);">
                        <h5 class="fw-bold mb-0"><i class="fas fa-headset me-2"></i> 24/7 Support</h5>
                        <p class="mb-0">Always available for you</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-7">
                <div class="d-flex align-items-center mb-3">
                    <div class="bg-warning rounded-circle p-2 me-3">
                        <i class="fas fa-trophy text-dark"></i>
                    </div>
                    <h2 class="fw-bold mb-0">Why <span class="text-warning">Choose Mega City Cab?</span></h2>
                </div>
                <p class="text-muted mb-4">We provide an efficient, computerized system to manage customer bookings, driver assignments, and billing. Our state-of-the-art platform ensures quick, reliable service every time.</p>
                <div class="row">
                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded mb-3 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-laptop fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Easy Online Booking</h5>
                                    <p class="mb-0 small">Book your ride with just a few clicks</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded mb-3 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-shield-alt fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Reliable & Secure</h5>
                                    <p class="mb-0 small">Safe travel with verified drivers</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded mb-3 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-receipt fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Automated Billing</h5>
                                    <p class="mb-0 small">Transparent pricing & discounts</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded mb-3 mb-md-0 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-user-tie fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Driver Management</h5>
                                    <p class="mb-0 small">Professional, trained drivers</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded mb-3 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-map-marked-alt fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Ride Tracking</h5>
                                    <p class="mb-0 small">Real-time location updates</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded mb-3 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-headset fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">24/7 Support</h5>
                                    <p class="mb-0 small">Help available anytime</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded mb-3 feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-book fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Usage Guidelines</h5>
                                    <p class="mb-0 small">Easy to follow instructions</p>
                                </div>
                            </div>
                        </div>
                        <div class="p-3 bg-light rounded feature-card">
                            <div class="d-flex">
                                <div class="flex-shrink-0 me-3 text-warning">
                                    <i class="fas fa-credit-card fa-2x"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold">Easy Payments</h5>
                                    <p class="mb-0 small">Multiple payment options</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Services Section -->
    <section id="services" class="py-5 bg-light">
        <div class="container">
            <div class="text-center mb-5">
                <h6 class="text-warning fw-bold text-uppercase">What We Offer</h6>
                <h2 class="fw-bold">Our Premium Taxi Services</h2>
                <p class="text-muted mx-auto" style="max-width: 600px;">Choose from our wide range of transportation options designed to meet your specific needs</p>
            </div>
            
            <div class="row g-4">
                <!-- City Taxi -->
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 service-card">
                        <div class="card-body p-4">
                            <div class="bg-warning rounded-circle p-3 d-inline-block mb-3">
                                <i class="fas fa-taxi fa-2x text-dark"></i>
                            </div>
                            <h4 class="fw-bold">City Taxi</h4>
                            <p class="text-muted">Quick, affordable rides within the city with no waiting time. Ideal for daily commutes.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Airport Transfer -->
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 service-card">
                        <div class="card-body p-4">
                            <div class="bg-warning rounded-circle p-3 d-inline-block mb-3">
                                <i class="fas fa-plane fa-2x text-dark"></i>
                            </div>
                            <h4 class="fw-bold">Airport Transfer</h4>
                            <p class="text-muted">Reliable airport pickup and drop-off service with flight tracking and waiting time.</p>                    
                        </div>
                    </div>
                </div>
                
                <!-- Premium Sedan -->
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100 service-card">
                        <div class="card-body p-4">
                            <div class="bg-warning rounded-circle p-3 d-inline-block mb-3">
                                <i class="fas fa-car fa-2x text-dark"></i>
                            </div>
                            <h4 class="fw-bold">Premium Sedan</h4>
                            <p class="text-muted">Luxury vehicle with professional driver for business meetings or special occasions.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Statistics Section -->
    <section class="stats-section text-white py-5 bg-dark">
        <div class="container text-center">
            <div class="row">
                <div class="col-md-3 col-6 mb-4 mb-md-0">
                    <div class="counter-box">
                        <i class="fa-solid fa-calendar-check fa-3x text-warning mb-3"></i>
                        <h3 class="counter fw-bold">10,000+</h3>
                        <p>Bookings Processed</p>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-4 mb-md-0">
                    <div class="counter-box">
                        <i class="fa-solid fa-user-check fa-3x text-warning mb-3"></i>
                        <h3 class="counter fw-bold">5,000+</h3>
                        <p>Registered Customers</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="counter-box">
                        <i class="fa-solid fa-car-side fa-3x text-warning mb-3"></i>
                        <h3 class="counter fw-bold">1,200+</h3>
                        <p>Active Vehicles</p>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="counter-box">
                        <i class="fa-solid fa-user-tie fa-3x text-warning mb-3"></i>
                        <h3 class="counter fw-bold">800+</h3>
                        <p>Professional Drivers</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Booking Section -->
    <section id="booking" class="py-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-8 text-center mb-5">
                    <h6 class="text-warning fw-bold text-uppercase">Book Your Ride</h6>
                    <h2 class="fw-bold mb-3">Easy 3-Step Booking Process</h2>
                    <p class="text-muted">Schedule your ride in advance or book instantly - our automated system makes it simple.</p>
                </div>
            </div>
            
            <div class="row justify-content-center">
                <div class="col-md-4 mb-4 mb-md-0">
                    <div class="card border-0 shadow-sm text-center h-100">
                        <div class="card-body p-4">
                            <div class="bg-warning rounded-circle mx-auto d-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                                <span class="fw-bold fs-3">1</span>
                            </div>
                            <h4 class="fw-bold">Enter Location</h4>
                            <p class="text-muted">Set your pickup and destination points for accurate fare calculation</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4 mb-md-0">
                    <div class="card border-0 shadow-sm text-center h-100">
                        <div class="card-body p-4">
                            <div class="bg-warning rounded-circle mx-auto d-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                                <span class="fw-bold fs-3">2</span>
                            </div>
                            <h4 class="fw-bold">Select Vehicle</h4>
                            <p class="text-muted">Choose from our range of vehicles based on your needs and group size</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm text-center h-100">
                        <div class="card-body p-4">
                            <div class="bg-warning rounded-circle mx-auto d-flex align-items-center justify-content-center mb-4" style="width: 80px; height: 80px;">
                                <span class="fw-bold fs-3">3</span>
                            </div>
                            <h4 class="fw-bold">Confirm & Pay</h4>
                            <p class="text-muted">Complete your booking with our secure payment system</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="text-center mt-5">
                <a href="booking.jsp" class="btn btn-warning btn-lg px-5">Book Now</a>
            </div>
        </div>
    </section>

    <!-- Reviews Section -->
    <section class="bg-warning py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-5 mb-4 mb-lg-0">
                    <h2 class="fw-bold">What Our Customers Say</h2>
                    <p class="text-dark">Mega City Cab has transformed the way customers book rides in Colombo. Hear from our happy customers.</p>
                    <div class="mt-4">
                        <button class="btn btn-dark me-2" data-bs-target="#testimonialCarousel" data-bs-slide="prev">
                            <i class="fa-solid fa-chevron-left"></i>
                        </button>
                        <button class="btn btn-dark" data-bs-target="#testimonialCarousel" data-bs-slide="next">
                            <i class="fa-solid fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div id="testimonialCarousel" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <!-- Review 1 -->
                            <div class="carousel-item active">
                                <div class="card p-4 border-0 shadow">
                                    <div class="d-flex align-items-center">
                                        <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="User">
                                        <div>
                                            <h5 class="mb-0">Dilan Perera</h5>
                                            <p class="text-muted mb-0">Regular Customer</p>
                                            <div class="text-warning">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <p class="mt-3">"Booking a cab has never been easier! The system is fast, and I get my ride within minutes. Great service!"</p>
                                </div>
                            </div>
                            <!-- Review 2 -->
                            <div class="carousel-item">
                                <div class="card p-4 border-0 shadow">
                                    <div class="d-flex align-items-center">
                                        <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="User">
                                        <div>
                                            <h5 class="mb-0">Rajitha Fernando</h5>
                                            <p class="text-muted mb-0">Business Traveler</p>
                                            <div class="text-warning">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star-half-alt"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <p class="mt-3">"Mega City Cab's computerized system is amazing. I can manage my bookings and track my rides easily!"</p>
                                </div>
                            </div>
                            <!-- Review 3 -->
                            <div class="carousel-item">
                                <div class="card p-4 border-0 shadow">
                                    <div class="d-flex align-items-center">
                                        <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="User">
                                        <div>
                                            <h5 class="mb-0">Samadhi Gunawardena</h5>
                                            <p class="text-muted mb-0">Frequent Traveler</p>
                                            <div class="text-warning">
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </div>
                                    </div>
                                    <p class="mt-3">"The automated billing system is great! I get my bill instantly after my ride, and the fare calculations are accurate."</p>
                                </div>
                            </div>
                        </div>
                        <div class="carousel-indicators position-relative mt-3">
                            <button type="button" data-bs-target="#testimonialCarousel" data-bs-slide-to="0" class="active bg-dark" aria-current="true"></button>
                            <button type="button" data-bs-target="#testimonialCarousel" data-bs-slide-to="1" class="bg-dark"></button>
                            <button type="button" data-bs-target="#testimonialCarousel" data-bs-slide-to="2" class="bg-dark"></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

   <!-- FAQ Section -->
   <section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center mb-5">
            <div class="col-lg-8 text-center">
                <h6 class="text-warning fw-bold text-uppercase">FAQ</h6>
                <h2 class="fw-bold">Frequently Asked Questions</h2>
                <p class="text-muted">Find answers to the most common questions about our service</p>
            </div>
        </div>

        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="accordion" id="faqAccordion">
                    <!-- FAQ Item 1 -->
                    <div class="accordion-item border-0 mb-3 shadow-sm">
                        <h2 class="accordion-header" id="headingOne">
                            <button class="accordion-button bg-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                How do I book a taxi?
                            </button>
                        </h2>
                        <div id="collapseOne" class="accordion-collapse collapse show" aria-labelledby="headingOne" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                You can book a taxi through our website, mobile app, or by calling our customer service. Simply enter your pickup location, destination, and preferred time to get an instant quote and confirm your booking.
                            </div>
                        </div>
                    </div>
                    
                    <!-- FAQ Item 2 -->
                    <div class="accordion-item border-0 mb-3 shadow-sm">
                        <h2 class="accordion-header" id="headingTwo">
                            <button class="accordion-button collapsed bg-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                How is the fare calculated?
                            </button>
                        </h2>
                        <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Our fares are calculated based on distance, time of day, and vehicle type. You'll always see the estimated fare before confirming your booking, and our system ensures transparent pricing with no hidden charges.
                            </div>
                        </div>
                    </div>
                    
                    <!-- FAQ Item 3 -->
                    <div class="accordion-item border-0 mb-3 shadow-sm">
                        <h2 class="accordion-header" id="headingThree">
                            <button class="accordion-button collapsed bg-white" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                Can I schedule a ride in advance?
                            </button>
                        </h2>
                        <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#faqAccordion">
                            <div class="accordion-body">
                                Yes, you can schedule rides up to 7 days in advance. Our system will automatically assign a driver at the requested time, and you'll receive notifications when your driver is on the way.
                            </div>
                        </div>
                    </div>                  
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Contact Section -->
<section id="contact" class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-5 mb-4 mb-lg-0">
                <h2 class="fw-bold mb-4">Get In Touch</h2>
                <p class="mb-4">Have questions or feedback? Reach out to our customer support team.</p>
                
                <div class="d-flex mb-4">
                    <div class="me-3">
                        <div class="bg-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 50px; height: 50px">
                            <i class="fas fa-map-marker-alt fa-lg"></i>
                        </div>
                    </div>
                    <div>
                        <h5 class="fw-bold">Our Location</h5>
                        <p class="mb-0">123 Galle Road, Colombo 03, Sri Lanka</p>
                    </div>
                </div>
                
                <div class="d-flex mb-4">
                    <div class="me-3">
                        <div class="bg-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 50px; height: 50px">
                            <i class="fas fa-phone-alt fa-lg"></i>
                        </div>
                    </div>
                    <div>
                        <h5 class="fw-bold">Call Us</h5>
                        <p class="mb-0">(568) 367-987-237</p>
                        <p class="mb-0">(112) 345-6789</p>
                    </div>
                </div>
                
                <div class="d-flex">
                    <div class="me-3">
                        <div class="bg-warning rounded-circle d-flex align-items-center justify-content-center" style="width: 50px; height: 50px">
                            <i class="fas fa-envelope fa-lg"></i>
                        </div>
                    </div>
                    <div>
                        <h5 class="fw-bold">Email Us</h5>
                        <p class="mb-0">info@megacitycab.com</p>
                        <p class="mb-0">support@megacitycab.com</p>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-body p-4">
                        <h4 class="fw-bold mb-4">Send us a message</h4>
                        <form>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <input type="text" class="form-control" placeholder="Your Name">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <input type="email" class="form-control" placeholder="Your Email">
                                </div>
                            </div>
                            <div class="mb-3">
                                <input type="text" class="form-control" placeholder="Subject">
                            </div>
                            <div class="mb-3">
                                <textarea class="form-control" rows="5" placeholder="Your Message"></textarea>
                            </div>
                            <button type="submit" class="btn btn-warning">Send Message</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer-section text-white py-5">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-4 mb-lg-0">
                <h4 class="text-warning fw-bold mb-4"><i class="fa-solid fa-taxi me-2"></i> Mega City Cab</h4>
                <p class="mb-4">Your trusted ride service in Colombo. Safe, reliable, and efficient transportation at your fingertips.</p>
                <div class="social-icons">
                    <a href="#" class="me-3"><i class="fab fa-facebook-f"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-twitter"></i></a>
                    <a href="#" class="me-3"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            
            <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                <h5 class="text-warning fw-bold mb-4">Quick Links</h5>
                <ul class="list-unstyled">
                    <li><a href="#home">Home</a></li>
                    <li><a href="#about">About Us</a></li>
                    <li><a href="#services">Services</a></li>
                    <li><a href="#booking">Booking</a></li>
                    <li><a href="#contact">Contact</a></li>
                </ul>
            </div>
            
            <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                <h5 class="text-warning fw-bold mb-4">Our Services</h5>
                <ul class="list-unstyled">
                    <li><a href="#">City Taxi</a></li>
                    <li><a href="#">Airport Transfer</a></li>
                    <li><a href="#">Premium Sedan</a></li>
                    <li><a href="#">Corporate Service</a></li>
                    <li><a href="#">Tourist Guide</a></li>
                </ul>
            </div>
            
            <div class="col-lg-4 col-md-4">
                <h5 class="text-warning fw-bold mb-4">Download Our App</h5>
                <p class="mb-3">Get our mobile app for the best booking experience</p>
                <div class="app-buttons">
                    <a href="#" class="btn btn-light me-2 mb-2">
                        <i class="fab fa-google-play me-2"></i> Google Play
                    </a>
                    <a href="#" class="btn btn-light mb-2">
                        <i class="fab fa-apple me-2"></i> App Store
                    </a>
                </div>
            </div>
        </div>
        
        <hr class="mt-4 mb-4 bg-secondary">
        
        <div class="row">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-0">&copy; 2025 Mega City Cab. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-center text-md-end">
                <a href="#" class="text-white me-3">Terms of Service</a>
                <a href="#" class="text-white">Privacy Policy</a>
            </div>
        </div>
    </div>
</footer>

<!-- Back to Top Button -->
<a href="#" class="back-to-top btn btn-warning rounded-circle position-fixed" style="bottom: 30px; right: 30px; width: 50px; height: 50px; display: flex; align-items: center; justify-content: center; z-index: 99;">
    <i class="fas fa-arrow-up"></i>
</a>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom Script -->
<script>
    // Show/hide back to top button based on scroll position
    window.addEventListener('scroll', function() {
        var backToTopBtn = document.querySelector('.back-to-top');
        if (window.pageYOffset > 300) {
            backToTopBtn.style.display = 'flex';
        } else {
            backToTopBtn.style.display = 'none';
        }
    });
    
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
        });
    });
</script>
</body>
</html>