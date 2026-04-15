# Classroom Mapping System — OLPC San Manuel Inc.

## Introduction
The Classroom Mapping System at Our Lady of the Pillar College – San Manuel Inc. (OLPC) represents a significant digital transformation from traditional, manual methods of academic scheduling and facility management. For years, the institution relied on manual logs and physical spreadsheets to manage room assignments across its three-floor campus, a process prone to human error, double-bookings, and logistical inefficiencies. This system was designed to centralize and automate these tasks, ensuring that every room, instructor, and student section is synchronized in a single, accessible digital environment.

By transitioning to this automated platform, OLPC aims to provide a more responsive and accurate scheduling experience for its staff and students. The system serves as the definitive source for classroom occupancy, offering real-time visibility into room availability and instructor loads. This modernization not only simplifies the administrative burden of scheduling but also enhances the overall academic environment by providing clear, conflict-free guidance for everyone on campus.


## Project Description
The Classroom Mapping System is a robust web-based platform built on the Microsoft ASP.NET framework, utilizing VB.NET for its core logic and a dedicated SQL Server database for secure, high-performance data persistence. The system is architected as an integrated suite of management modules, including dedicated pages for scheduling classrooms across three campus floors, managing academic subjects, and overseeing instructor profiles and their respective teaching loads. Its user interface is designed to be responsive and intuitive, using modern CSS techniques to provide a seamless experience on both desktop and mobile devices.

At the heart of the application is a sophisticated role-based access control (RBAC) system, which defines four distinct user levels: Admin, Dean, Instructor, and Student. This ensures that while students can only view schedules relevant to their own courses, administrators and deans have the necessary tools to manage the entire institution's academic data. Instructors are empowered to manage their own schedules and subjects, but are restricted from modifying the records of their colleagues, maintaining a secure and professional environment for all staff members.

A defining technical feature of the system is its automated triple-conflict detection engine. This logic, applied every time a classroom slot is assigned or updated, simultaneously checks for room availability, instructor teaching conflicts, and student section overlaps. This real-time validation prevents the most common errors in academic scheduling, ensuring that the final output is 100% accurate and conflict-free. Additionally, the system includes an automated report generation tool that produces official, printable Teaching Load documents, streamlining the administrative paperwork required for each semester.


## Project Objectives

### General Objective
To design, develop, and implement a centralized digital platform for managing the classroom mapping and academic scheduling for Our Lady of the Pillar College – San Manuel Inc., thereby enhancing its administrative efficiency and data accuracy.

### Specific Objectives
- **Digital Centralization:** To consolidate all classroom assignments, subject metadata, and instructor teaching loads into a single, secure SQL Server database, replacing fragmented manual systems.
- **Conflict Prevention:** To implement an automated triple-conflict detection engine that simultaneously validates room availability, instructor teaching slots, and student section schedules.
- **Secure Access Management:** To provide a role-based access control system that allows students read-only access to relevant schedules while giving administrators, deans, and instructors the appropriate management tools.
- **Automated Reporting:** To automate the generation of official Teaching Load reports, ensuring that every instructor's academic load is accurately calculated and ready for official signatures.
- **Data Integrity:** To ensure secure and private access to the system through SHA-256 hashed password authentication and role-specific data filtering.
- **User-Centric Design:** To offer an intuitive, web-based interface that allows instructors and administrators to manage their daily scheduling tasks through simple, click-to-edit interactions.
