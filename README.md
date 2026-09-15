# Despliegue con Docker Compose - Software Educativo de Sistemas Expertos

Este directorio contiene la orquestación completa con **Docker Compose** para levantar en un solo comando:
1. **Base de Datos**: PostgreSQL 16
2. **Backend**: Django 5.1 REST Framework con Gunicorn y Swagger/OpenAPI
3. **Frontend**: React 19 + Vite compilado y servido a través de Nginx

---

## 1. Requisitos Previos

- **Docker Desktop** (versión 24 o superior) instalado y en ejecución.
- **Docker Compose** v2 (incluido en Docker Desktop).

---

## 2. Servicios Orquestados

| Servicio | Contenedor | Puerto Host | Descripción |
| :--- | :--- | :--- | :--- |
| **db** | `sistema_experto_db` | `5432` | PostgreSQL 16 con volumen persistente (`postgres_data`) |
| **back** | `sistema_experto_back` | `8000` | API Django REST con Gunicorn, migraciones automáticas y Swagger |
| **front** | `sistema_experto_front` | `3000` | Frontend React + Tailwind servido con Nginx |

---

## 3. Instrucciones de Uso

### Paso 1: Abrir una terminal en este directorio
```bash
cd SW_Sistema_experto_despliegue
```

### Paso 2: Construir y levantar todos los servicios
Para levantar los contenedores en segundo plano (modo detached):
```bash
docker compose up --build -d
```

O para ver los logs en tiempo real en la terminal:
```bash
docker compose up --build
```

> **Nota:** En el primer arranque, el backend espera automáticamente a que PostgreSQL esté listo, ejecuta las migraciones (`python manage.py migrate`), recolecta archivos estáticos (`collectstatic`) y carga los datos de prueba (`seed_sprint1`).

---

## 4. URLs de Acceso

Una vez levantados los servicios, accede desde tu navegador:

- **Frontend (Aplicación Web)**: [http://localhost:3000](http://localhost:3000)
- **Documentación Swagger / OpenAPI**: [http://localhost:8000/api/docs/](http://localhost:8000/api/docs/)
- **Documentación ReDoc**: [http://localhost:8000/api/redoc/](http://localhost:8000/api/redoc/)
- **Esquema OpenAPI JSON**: [http://localhost:8000/api/schema/](http://localhost:8000/api/schema/)
- **Endpoint Raíz de la API**: [http://localhost:8000/api/v1/sistemas-expertos/](http://localhost:8000/api/v1/sistemas-expertos/)

---

## 5. Comandos Útiles de Mantenimiento

### Ver logs de los servicios
```bash
# Ver logs de todos los servicios
docker compose logs -f

# Ver logs únicamente del backend
docker compose logs -f back

# Ver logs únicamente del frontend
docker compose logs -f front
```

### Detener los servicios
```bash
docker compose down
```

### Detener y eliminar volúmenes (reinicio limpio de base de datos)
```bash
docker compose down -v
```

### Ejecutar comandos dentro del backend
```bash
# Ejecutar migraciones manualmente
docker compose exec back python manage.py migrate

# Ejecutar el seeder nuevamente
docker compose exec back python manage.py seed_sprint1

# Abrir el shell interactivo de Django
docker compose exec back python manage.py shell

# Ejecutar la suite de pruebas pytest
docker compose exec back pytest -v
```

---

## 6. Variables de Entorno

Puedes modificar el archivo `.env` en este directorio para cambiar:
- `FRONT_PORT`: Puerto donde se expone la web (por defecto `3000`).
- `BACK_PORT`: Puerto donde se expone la API (por defecto `8000`).
- `DB_PORT`: Puerto de PostgreSQL en el host (por defecto `5432`).
- `SEED_DATA`: `true` para poblar el sistema experto de demostración al iniciar.
