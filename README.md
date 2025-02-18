# 📝 ToDoey List App

📱 Aplicación móvil para la gestión de tareas desarrollada en Flutter y Firebase


<img width="444" alt="Screenshot 2025-02-17 at 2 41 56 PM" src="https://github.com/user-attachments/assets/8f240832-acf3-41a6-8e2f-6e3756e1cddb" />
<img width="456" alt="Screenshot 2025-02-17 at 2 39 33 PM" src="https://github.com/user-attachments/assets/b37687e0-6c63-49ee-9b66-3028e73addcc" />
<img width="463" alt="Screenshot 2025-02-17 at 2 43 10 PM" src="https://github.com/user-attachments/assets/8f9761e5-71ac-48c8-81f3-7f7cb86de465" />
<img width="462" alt="Screenshot 2025-02-17 at 2 43 34 PM" src="https://github.com/user-attachments/assets/ac0c6a62-cb8f-42c3-8b4b-234de8e9fd47" />



https://github.com/user-attachments/assets/9bc8b4d1-f88f-4e40-9a4a-49bfd69da752

https://github.com/user-attachments/assets/5ea8d43c-e02d-4a7d-97e2-ac7e16e24f2b



## 🎯 Objetivo
Esta aplicación permite organizar tareas de manera eficiente. 

✅ Permite crear un tema de tareas en general

📝 Items de tareas , que se agregan a la lista de tareas grande

📌 Estado (pendiente o completada) (por medio de checkbox)

📅 Fecha

## 🚀 Funcionalidades

✅ Agregar tareas y guardarlas en Firebase Cloud Firestore

🌍 Traducción automática de la tarea a inglés mediante Firebase Cloud Functions

📌 Ordenamiento de tareas por fecha y estado

🌐 Mostrar versión traducida de la tarea

✏️ Marcar tareas como completadas

🗑 Eliminar tareas existentes

## 🏗 Arquitectura

Este proyecto sigue el enfoque de Arquitectura Limpia, dividiendo el código en capas bien definidas:

✨ Presentación: UI + Estado administrado con BLoC y flutter_bloc

✨ Dominio: Casos de uso y lógica de negocio

✨ Datos: Repositorios y acceso a Firestore

## Modelo de datos

- **📂 Colección (`todoLists`)** → Contiene todas las listas de tareas creadas por los usuarios.
- **📄 Documento (`{todoListId}`)** → Representa una lista de tareas con sus atributos:
  - `createdAt` → Marca de tiempo de creación.
  - `title` → Nombre de la lista de tareas.
  - `userId` → Identificador único del usuario propietario.
- **📂 Subcolección (`items`)** → Contiene las tareas individuales dentro de una lista.
- **📄 Documento (`{itemId}`)** → Representa una tarea específica con sus atributos:
  - `createdAt` → Marca de tiempo de creación.
  - `description` → Descripción de la tarea.
  - `id` → Identificador único de la tarea.
  - `isCompleted` → Indica si la tarea está completada (true/false).
  - `translation` → Traducción de la descripción de la tarea.

Este modelo de datos es flexible y escalable, permitiendo gestionar listas de tareas y sus elementos en Firestore. 🚀


 ### Desarrollado con ❤️ en Flutter 🚀

