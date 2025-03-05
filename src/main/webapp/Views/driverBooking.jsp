<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Ensure only drivers can access.
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equalsIgnoreCase("Driver")) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    
    // Retrieve message and booking lists set by the servlet.
    String message = (String) request.getAttribute("message");
    java.util.List<com.megacitycab.model.Booking> pendingBookings = 
        (java.util.List<com.megacitycab.model.Booking>) request.getAttribute("pendingBookings");
    java.util.List<com.megacitycab.model.Booking> acceptedBookings = 
        (java.util.List<com.megacitycab.model.Booking>) request.getAttribute("acceptedBookings");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Driver Bookings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
</head>
<body class="bg-gray-100">
    <div class="max-w-4xl mx-auto py-8">
        <h1 class="text-2xl font-bold mb-4">Driver Bookings</h1>
        
        <% if(message != null){ %>
            <div class="bg-green-100 text-green-800 p-4 mb-4 rounded">
                <%= message %>
            </div>
        <% } %>
        
        <!-- Pending Bookings Section -->
        <h2 class="text-xl font-semibold mb-2">Pending Bookings (Matching Your Vehicle Type)</h2>
        <% if (pendingBookings == null || pendingBookings.isEmpty()) { %>
            <p>No pending bookings found.</p>
        <% } else { %>
            <table class="min-w-full bg-white border border-gray-300 mb-8">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2">Booking ID</th>
                        <th class="px-4 py-2">Customer ID</th>
                        <th class="px-4 py-2">Pickup</th>
                        <th class="px-4 py-2">Destination</th>
                        <th class="px-4 py-2">Distance (km)</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (com.megacitycab.model.Booking b : pendingBookings) { %>
                        <tr class="border-b border-gray-300">
                            <td class="px-4 py-2"><%= b.getBookingId() %></td>
                            <td class="px-4 py-2"><%= b.getCustomerId() %></td>
                            <td class="px-4 py-2"><%= b.getPickupLocation() %></td>
                            <td class="px-4 py-2"><%= b.getDestination() %></td>
                            <td class="px-4 py-2"><%= b.getDistanceKm() %></td>
                            <td class="px-4 py-2"><%= b.getStatus() %></td>
                            <td class="px-4 py-2">
                                <form action="<%= request.getContextPath() %>/manageDriverBooking" method="post">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                    <select name="newStatus" class="border p-1">
                                        <!-- For a pending booking, driver can pick from Active, Ongoing, or Completed -->
                                        <option value="Active">Active</option>
                                        <option value="Ongoing">Ongoing</option>
                                        <option value="Completed">Completed</option>
                                    </select>
                                    <button type="submit" class="bg-blue-500 text-white px-2 py-1 rounded">Update</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
        
        <!-- Accepted Bookings Section -->
        <h2 class="text-xl font-semibold mb-2">Accepted Bookings (Active/Ongoing)</h2>
        <% if (acceptedBookings == null || acceptedBookings.isEmpty()) { %>
            <p>No accepted bookings found.</p>
        <% } else { %>
            <table class="min-w-full bg-white border border-gray-300">
                <thead class="bg-gray-200">
                    <tr>
                        <th class="px-4 py-2">Booking ID</th>
                        <th class="px-4 py-2">Customer ID</th>
                        <th class="px-4 py-2">Pickup</th>
                        <th class="px-4 py-2">Destination</th>
                        <th class="px-4 py-2">Distance (km)</th>
                        <th class="px-4 py-2">Status</th>
                        <th class="px-4 py-2">Action</th> <!-- <-- ADD this column for updates -->
                    </tr>
                </thead>
                <tbody>
                    <% for (com.megacitycab.model.Booking b : acceptedBookings) { %>
                        <tr class="border-b border-gray-300">
                            <td class="px-4 py-2"><%= b.getBookingId() %></td>
                            <td class="px-4 py-2"><%= b.getCustomerId() %></td>
                            <td class="px-4 py-2"><%= b.getPickupLocation() %></td>
                            <td class="px-4 py-2"><%= b.getDestination() %></td>
                            <td class="px-4 py-2"><%= b.getDistanceKm() %></td>
                            <td class="px-4 py-2"><%= b.getStatus() %></td>
                            <td class="px-4 py-2">
                                <!-- The same form, so driver can update from Active->Ongoing->Completed or vice versa -->
                                <form action="<%= request.getContextPath() %>/manageDriverBooking" method="post">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                    <select name="newStatus" class="border p-1">
                                        <!-- The driver can choose any relevant next step -->
                                        <option value="Active" <%= b.getStatus().equalsIgnoreCase("Active") ? "selected" : "" %>>Active</option>
                                        <option value="Ongoing" <%= b.getStatus().equalsIgnoreCase("Ongoing") ? "selected" : "" %>>Ongoing</option>
                                        <option value="Completed" <%= b.getStatus().equalsIgnoreCase("Completed") ? "selected" : "" %>>Completed</option>
                                    </select>
                                    <button type="submit" class="bg-blue-500 text-white px-2 py-1 rounded">Update</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
        
        <br>
        <a href="<%= request.getContextPath() %>/Views/home.jsp" class="bg-blue-500 text-white px-4 py-2 rounded">Back to Home</a>
    </div>
</body>
</html>
