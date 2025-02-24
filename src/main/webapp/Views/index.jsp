<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ include file="Navigation/hedding.jsp" %>

<!-- Hero Section -->
<section class="hero-section mt-3 d-flex align-items-center position-relative">
    <div class="container">
        <div class="row align-items-center">
            <!-- Left Column (Text Content) -->
            <div class="col-lg-6 text-content">
                <h1 class="fw-bold display-5">Your Trusted Ride in Colombo</h1>
                <p class="fs-5">
                    Mega City Cab provides safe, fast, and affordable taxi services. 
                    With our new digital booking system, you can schedule your ride in 
                    seconds, track your driver, and enjoy a hassle-free journey.
                </p>

                <!-- Ride Booking Form -->
                <div class="ride-form d-flex gap-2 my-3">
                    <input type="text" class="form-control rounded-pill px-3" placeholder="Pickup location">
                    <input type="text" class="form-control rounded-pill px-3" placeholder="Drop location">
                </div>

                <div class="ride-form">
                    <button class="btn btn-dark w-100 btn-lg rounded-pill">
                        Find A Taxi <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <!-- Right Column (Image) -->
            <div class="col-lg-6 text-center position-relative">
			<img src="/Mega_City_Cab/Assets/Images/cab.png" class="hero-image img-fluid" alt="Mega City Cab Illustration">
            </div>
        </div>
    </div>

    <!-- Curved Bottom Shape -->
    <div class="hero-wave">
        <svg viewBox="0 0 1440 320">
            <path fill="white" fill-opacity="1" 
                d="M0,192L48,192C96,192,192,192,288,176C384,160,480,128,576,117.3C672,107,768,117,864,144C960,171,1056,213,1152,213.3C1248,213,1344,171,1392,149.3L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z">
            </path>
        </svg>
    </div>
</section>


    <!-- Why Choose Us Section -->
    <section class="container my-5">
        <div class="row align-items-center">
            <div class="col-lg-5 text-center">
				<img src="/Mega_City_Cab/Assets/Images/taxi-service.png" class="img-fluid rounded shadow mb-3" alt="Mega City Cab">
            </div>
            <div class="col-lg-7">
                <h2 class="fw-bold">Why <span class="text-warning">Choose Mega City Cab?</span></h2>
                <p class="text-muted">We provide an efficient, computerized system to manage customer bookings, driver assignments, and billing.</p>
                <div class="row">
                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>Easy Online Booking</strong></div>
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>Reliable & Secure Rides</strong></div>
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>Automated Billing & Discounts</strong></div>
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>Driver & Vehicle Management</strong></div>
                    </div>
                    <div class="col-md-6">
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>Instant Ride Tracking</strong></div>
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>24/7 Customer Support</strong></div>
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>System Usage Guidelines</strong></div>
                        <div class="p-3 bg-light rounded mb-2">✅ <strong>Fast & Easy Payments</strong></div>
                    </div>
                </div>
            </div>
        </div>
    </section>

   <!-- Statistics Section -->
    <section class="stats-section text-white py-5 bg-dark">
        <div class="container text-center">
            <div class="row">
                <div class="col-md-3">
                    <i class="fa-solid fa-calendar-check fa-3x text-warning"></i>
                    <h3>10,000+</h3>
                    <p>Bookings Processed</p>
                </div>
                <div class="col-md-3">
                    <i class="fa-solid fa-user-check fa-3x text-warning"></i>
                    <h3>5,000+</h3>
                    <p>Registered Customers</p>
                </div>
                <div class="col-md-3">
                    <i class="fa-solid fa-car-side fa-3x text-warning"></i>
                    <h3>1,200+</h3>
                    <p>Active Vehicles</p>
                </div>
                <div class="col-md-3">
                    <i class="fa-solid fa-user-tie fa-3x text-warning"></i>
                    <h3>800+</h3>
                    <p>Professional Drivers</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Reviews Section -->
    <section class="bg-warning py-5">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-5">
                    <h2 class="fw-bold">What Our Customers Say</h2>
                    <p class="text-dark">Mega City Cab has transformed the way customers book rides in Colombo. Hear from our happy customers.</p>
                    <button class="btn btn-dark me-2" data-bs-target="#testimonialCarousel" data-bs-slide="prev">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <button class="btn btn-dark" data-bs-target="#testimonialCarousel" data-bs-slide="next">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </div>
                <div class="col-lg-7">
                    <div id="testimonialCarousel" class="carousel slide" data-bs-ride="carousel">
                        <div class="carousel-inner">
                            <!-- Review 1 -->
                            <div class="carousel-item active">
                                <div class="card p-4">
                                    <div class="d-flex align-items-center">
                                        <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="User">
                                        <div>
                                            <h5 class="mb-0">Dilan Perera</h5>
                                            <p class="text-muted">Regular Customer</p>
                                        </div>
                                    </div>
                                    <p class="mt-3">"Booking a cab has never been easier! The system is fast, and I get my ride within minutes. Great service!"</p>
                                </div>
                            </div>
                            <!-- Review 2 -->
                            <div class="carousel-item">
                                <div class="card p-4">
                                    <div class="d-flex align-items-center">
                                        <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="User">
                                        <div>
                                            <h5 class="mb-0">Rajitha Fernando</h5>
                                            <p class="text-muted">Business Traveler</p>
                                        </div>
                                    </div>
                                    <p class="mt-3">"Mega City Cab's computerized system is amazing. I can manage my bookings and track my rides easily!"</p>
                                </div>
                            </div>
                            <!-- Review 3 -->
                            <div class="carousel-item">
                                <div class="card p-4">
                                    <div class="d-flex align-items-center">
                                        <img src="https://via.placeholder.com/50" class="rounded-circle me-3" alt="User">
                                        <div>
                                            <h5 class="mb-0">Samadhi Gunawardena</h5>
                                            <p class="text-muted">Frequent Traveler</p>
                                        </div>
                                    </div>
                                    <p class="mt-3">"The automated billing system is great! I get my bill instantly after my ride, and the fare calculations are accurate."</p>
                                </div>
                            </div>
                        </div>
                        <div class="carousel-indicators">
                            <button type="button" data-bs-target="#testimonialCarousel" data-bs-slide-to="0" class="active"></button>
                            <button type="button" data-bs-target="#testimonialCarousel" data-bs-slide-to="1"></button>
                            <button type="button" data-bs-target="#testimonialCarousel" data-bs-slide-to="2"></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

<!-- Include the Footer -->
<%@ include file="Navigation/footer.jsp" %>

<!-- Include Scripts -->
<%@ include file="../Assests/scripts.jsp" %>

</body>
</html>
