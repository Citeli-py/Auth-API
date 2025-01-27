# Auth-API

Esta é uma API simples de autenticação construída com Ruby on Rails. Ela oferece funcionalidades como registro de usuários, login, acesso a áreas restritas e redefinição de senha.

---

## Em reforma

## **Endpoints**

### **1. Registro de Usuário**
- **URL:** `/register`
- **Método:** `POST`
- **Descrição:** Cria um novo usuário no sistema.

#### **Exemplo de Requisição:**
```json
{
  "user": {
    "email": "cici@example.com",
    "password": "12345678",
    "password_confirmation": "12345678"
  }
}
```

#### **Exemplo de resposta:**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "email": "cici@example.com",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJleHAiOkE3MzQwNTYwMDF9.cc4988b2700bc744144c7195ba86b486ccc68891d8e74d73a90c508165d211e9"
  }
}
```

### **2. Login de Usuário**
- **URL**: `/login`
- **Método**: `POST`
- **Descrição**: Autentica um usuário existente.

#### Exemplo de Requisição:
```json
{
  "user": {
    "email": "cici@example.com",
    "password": "12345678"
  }
}
```
#### Exemplo de Resposta:
```json
{
  "message": "Login successful",
  "user": {
    "id": 1,
    "email": "cici@example.com",
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJleHAkOjE3MzQwNTYwMDF9.cc4988b2700bc744144c7195ba86b486ccc68891d8e74d73a90c508165d211e9"
  }
}
```

### 3. Área Restrita
- **URL**: `/restricted`
- **Método**: `GET`
- **Descrição**: Endpoint que requer autenticação para acesso.

#### **Cabeçalho de Autorização:**
```bash
Authorization: Bearer <token>
```

#### **Exemplo de Resposta (Sucesso):**

```json
{
  "message": "Access granted to restricted area"
}
```

#### **Exemplo de Resposta (Erro - Token Inválido ou Ausente):**

```json
{
	"errors": "Token is invalid"
}
```

### 4. Redefinição de Senha

- URL: /change_password
- Método: POST
- Descrição: Atualiza a senha de um usuário.

#### **Exemplo de Requisição:**

```json
{
  "user": {
    "email": "example@example.com",
    "old_password": "123456789",
    "password": "12345678",
    "password_confirmation": "12345678"
  }
}
```

#### **Exemplo de Resposta:**
```json
{
  "message": "Password change success"
}
```

## **Autenticação**
A autenticação é realizada através de tokens JWT. Após o registro ou login, o token recebido deve ser enviado no cabeçalho de autorização para acessar endpoints protegidos.


```bash
curl -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MzQwNTYwMDF9.cc4988b2700bc744144c7195ba86b486ccc68891d8e74d73a90c508165d211e9" https://auth-api-production-81af.up.railway.app/restricted
```

## Acesso

Essa API está disponível para teste no link: https://auth-api-production-81af.up.railway.app
