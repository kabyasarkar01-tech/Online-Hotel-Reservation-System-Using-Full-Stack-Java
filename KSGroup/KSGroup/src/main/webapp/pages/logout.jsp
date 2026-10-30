<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
/*
 * Prevent browser from caching the logout page.
 */
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);


/*
 * Destroy the customer's session.
 */
session.invalidate();


/*
 * Show logout message.
 */
response.sendRedirect(
    "message.jsp?msg="+
    java.net.URLEncoder.encode(
        "Logged Out Successfully.",
        "UTF-8"
    )
    +"&nextPage=../index.jsp"
    +"&button="+
    java.net.URLEncoder.encode(
        "Home",
        "UTF-8"
    )
);

return;
%>