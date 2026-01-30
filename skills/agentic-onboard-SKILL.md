---
name: agentic-onboard
description: Analiza un proyecto existente y genera un briefing completo para orientar al agente. Usa al inicio de cada sesión o cuando llegues a un proyecto desconocido.
---

# AGENTIC-ONBOARD

Skill para orientar agentes en proyectos existentes siguiendo AGENTIC-SPEC.

## Cuándo Usar

- Inicio de sesión en proyecto desconocido
- Usuario pide "entiende este proyecto", "onboard", "oriéntate"
- Antes de hacer cambios significativos en proyecto nuevo
- Cuando el agente no tiene contexto del proyecto

## Proceso de Onboarding

### Fase 1: Detección de Estructura

Buscar en orden de prioridad:

```
1. .agent/config.yaml      → Configuración completa del proyecto
2. AGENTS.md               → Reglas y patrones
3. README.md               → Descripción general
4. docs/architecture/      → Decisiones arquitectónicas
5. docs/invariants/        → Reglas inviolables
```

Si existe `.agent/config.yaml`, el proyecto sigue AGENTIC-SPEC.
Si no existe, inferir información de archivos estándar.

### Fase 2: Análisis del Proyecto

Ejecutar estas verificaciones:

```bash
# 1. Estructura de directorios
ls -la
find . -type f -name "*.md" | head -20

# 2. Detectar lenguaje/stack
# Buscar archivos de configuración característicos:
# - package.json → Node/JS/TS
# - pyproject.toml, requirements.txt → Python
# - go.mod → Go
# - Cargo.toml → Rust
# - pom.xml, build.gradle → Java
# - Gemfile → Ruby

# 3. Estado de tests
# Ejecutar comando de test del proyecto (si se conoce)

# 4. Estado de git
git log --oneline -5
git status --short
git branch --list
```

### Fase 3: Lectura de Documentación

Leer en este orden (si existen):

1. **`.agent/config.yaml`**: Extraer stack, comandos, boundaries
2. **`AGENTS.md`**: Extraer patrones obligatorios y restricciones
3. **`docs/architecture/INDEX.md`**: Listar ADRs activos
4. **`docs/invariants/INVARIANTS.md`**: Identificar reglas críticas
5. **AGENTS.md por módulo**: Si hay que trabajar en módulo específico

### Fase 4: Generar Briefing

---

## Formato del Briefing

```markdown
# 🗺️ Briefing del Proyecto

## Identidad
- **Nombre**: {nombre del proyecto}
- **Descripción**: {descripción breve}
- **Stack**: {lenguaje} + {framework} + {database}

## Estructura
```
{árbol de directorios principales, max 15 líneas}
```

## Comandos Disponibles
```bash
{comando_build}    # Build
{comando_test}     # Tests
{comando_lint}     # Lint
{comando_format}   # Format
```

## Módulos Principales
| Módulo | Propósito | Tests |
|--------|-----------|-------|
| {módulo} | {propósito} | ✅/❌ |

## Estado Actual
- **Branch**: {branch actual}
- **Último commit**: {mensaje del último commit}
- **Cambios pendientes**: {archivos modificados}
- **Tests**: {X passing, Y failing}

## Decisiones Arquitectónicas
| ID | Tema | 
|----|------|
| ADR-0001 | {tema} |
| ADR-0002 | {tema} |

## Invariantes Críticas
- 🔴 {invariante crítica 1}
- 🔴 {invariante crítica 2}

## Restricciones
- NUNCA: {restricción 1}
- NUNCA: {restricción 2}
- Confirmar antes de modificar: {archivos protegidos}

## Alertas
{si hay tests fallando, cambios sin commit, TODOs críticos, etc.}

---
✅ Onboarding completo. Listo para trabajar.
```

---

## Detección de Stack (sin config.yaml)

Si no existe `.agent/config.yaml`, inferir del proyecto:

### Node.js / TypeScript
```
Detectar: package.json
Leer: 
  - name, description
  - scripts (build, test, lint)
  - dependencies principales
```

### Python
```
Detectar: pyproject.toml, setup.py, requirements.txt
Leer:
  - [project] name, description
  - [tool.pytest], [tool.ruff]
  - dependencies
```

### Go
```
Detectar: go.mod
Leer:
  - module name
  - go version
  - require (dependencies)
```

### Rust
```
Detectar: Cargo.toml
Leer:
  - [package] name, description
  - [dependencies]
```

### Java
```
Detectar: pom.xml, build.gradle
Leer:
  - groupId, artifactId
  - dependencies
```

---

## Comandos Inferidos por Stack

Si no hay config explícito, usar defaults:

| Stack | Test | Lint | Build |
|-------|------|------|-------|
| Node (npm) | `npm test` | `npm run lint` | `npm run build` |
| Node (pnpm) | `pnpm test` | `pnpm lint` | `pnpm build` |
| Python (pytest) | `pytest` | `ruff check .` | `pip install -e .` |
| Python (poetry) | `poetry run pytest` | `poetry run ruff check .` | `poetry build` |
| Go | `go test ./...` | `golangci-lint run` | `go build ./...` |
| Rust | `cargo test` | `cargo clippy` | `cargo build` |
| Java (Maven) | `mvn test` | `mvn checkstyle:check` | `mvn package` |
| Java (Gradle) | `./gradlew test` | `./gradlew check` | `./gradlew build` |

---

## Análisis de Módulos

Para cada directorio en `src/`:

1. **Contar archivos** de código vs tests
2. **Detectar AGENTS.md** local (si existe)
3. **Identificar exports** principales
4. **Verificar cobertura** de tests

```markdown
## Módulos

| Módulo | Archivos | Tests | Cobertura | AGENTS.md |
|--------|----------|-------|-----------|-----------|
| users | 5 | 4 | 80% | ✅ |
| tasks | 8 | 6 | 75% | ✅ |
| notifications | 3 | 1 | 33% | ❌ |
```

---

## Detección de Problemas

Alertar sobre:

### 🔴 Críticos
- Tests fallando
- Archivos de entorno (.env) en git
- Secrets en código (buscar patrones: API_KEY, password, token)
- Migraciones pendientes

### 🟠 Importantes  
- Cobertura de tests < 50%
- TODOs/FIXMEs en código
- Dependencias desactualizadas (si es detectable)
- Archivos muy grandes (> 500 líneas)

### 🟡 Informativos
- Branches locales sin merge
- Cambios sin commit
- Documentación desactualizada (fechas antiguas en ADRs)

---

## Briefing Mínimo (proyecto sin AGENTIC-SPEC)

Si el proyecto no sigue la spec, generar briefing reducido:

```markdown
# 🗺️ Briefing del Proyecto

## Identidad
- **Nombre**: {inferido de config o directorio}
- **Stack**: {inferido de archivos de config}

## Estructura
```
{árbol básico}
```

## Comandos (inferidos)
```bash
{comandos por defecto del stack}
```

## Estado
- **Branch**: {branch}
- **Último commit**: {commit}

## ⚠️ Proyecto sin AGENTIC-SPEC

Este proyecto no sigue la especificación AGENTIC-SPEC.
Recomendaciones:
1. Revisar README.md para entender el proyecto
2. Buscar documentación en /docs si existe
3. Preguntar al usuario sobre patrones y restricciones
4. Considerar ejecutar `/agentic-bootstrap` para estructurar

---
⚠️ Onboarding parcial. Proceder con cautela.
```

---

## Integración con Sesión

Después del briefing, el agente debe:

1. **Recordar** el stack y comandos durante la sesión
2. **Respetar** las restricciones identificadas
3. **Consultar** ADRs antes de decisiones arquitectónicas
4. **Verificar** invariantes antes de commits

## Comando de Actualización

Si el proyecto cambia durante la sesión:

```
/onboard --refresh
```

Regenera solo las secciones dinámicas:
- Estado de git
- Tests passing/failing
- Cambios pendientes

---

## Ejemplo de Output

```markdown
# 🗺️ Briefing del Proyecto

## Identidad
- **Nombre**: task-manager
- **Descripción**: API REST para gestión de tareas con soporte multiusuario
- **Stack**: Python 3.12 + FastAPI + PostgreSQL + SQLAlchemy

## Estructura
```
src/
├── users/          # Autenticación y gestión de usuarios
├── tasks/          # CRUD de tareas y asignaciones
├── notifications/  # Sistema de notificaciones
└── shared/         # Utilidades compartidas
tests/
├── integration/
└── fixtures/
docs/
├── architecture/   # 4 ADRs
└── invariants/
```

## Comandos Disponibles
```bash
pytest                    # Tests
pytest src/tasks/         # Tests de módulo
ruff check .              # Lint
ruff format .             # Format
alembic upgrade head      # Migraciones
```

## Módulos Principales
| Módulo | Archivos | Tests | AGENTS.md |
|--------|----------|-------|-----------|
| users | 6 | 5 | ✅ |
| tasks | 9 | 8 | ✅ |
| notifications | 4 | 2 | ❌ |
| shared | 3 | 3 | ❌ |

## Estado Actual
- **Branch**: feature/recurring-tasks
- **Último commit**: feat(tasks): add recurrence field to task model
- **Cambios pendientes**: 2 archivos modificados
- **Tests**: 43 passing, 2 failing

## Decisiones Arquitectónicas
| ID | Tema |
|----|------|
| ADR-0001 | Stack: Python + FastAPI |
| ADR-0002 | PostgreSQL para persistencia |
| ADR-0003 | JWT para autenticación |
| ADR-0004 | Soft delete para todas las entidades |

## Invariantes Críticas
- 🔴 INV-001: Validar toda entrada con Pydantic
- 🔴 INV-002: Autenticación obligatoria excepto /health y /auth
- 🔴 INV-003: Soft delete (nunca DELETE físico)
- 🔴 INV-004: Transacciones para operaciones multi-tabla

## Restricciones
- NUNCA: Modificar alembic/versions/ sin migración nueva
- NUNCA: Hardcodear credenciales
- Confirmar antes: pyproject.toml, .github/workflows/

## Alertas
- 🔴 2 tests fallando en `src/tasks/recurrence.test.py`
- 🟡 Módulo notifications con baja cobertura (50%)

---
✅ Onboarding completo. Listo para trabajar.
```

---

## Notas de Implementación

- El briefing debe caber en ~1000 tokens para no consumir contexto
- Priorizar información accionable sobre exhaustividad
- Si el proyecto es muy grande, mostrar solo top-level + módulo relevante
- Cachear resultado en memoria durante la sesión
