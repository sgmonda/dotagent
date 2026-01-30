---
name: agentic-bootstrap
description: Inicializa un proyecto nuevo siguiendo AGENTIC-SPEC v1.0. Crea estructura de directorios, configuración para agentes, documentación arquitectónica y módulo de ejemplo con TDD.
---

# AGENTIC-BOOTSTRAP

Skill para inicializar proyectos optimizados para desarrollo con agentes de IA.

## Cuándo Usar

- Usuario pide crear un proyecto nuevo
- Usuario quiere estructurar un proyecto existente para agentes
- Palabras clave: "nuevo proyecto", "inicializar", "bootstrap", "crear proyecto", "setup"

## Información Requerida

Antes de generar, necesitas saber:

1. **Stack tecnológico**:
   - Lenguaje y versión
   - Framework principal
   - Base de datos (si aplica)
   - ORM/query builder (si aplica)
   - Framework de testing

2. **Dominio/propósito** del proyecto

3. **Nombre del proyecto**

Si el usuario no proporciona esta información, pregunta de forma concisa:

```
Para crear el proyecto necesito:
- Stack: ¿Lenguaje + framework + DB?
- Dominio: ¿Qué problema resuelve?
- Nombre: ¿Cómo se llama el proyecto?
```

---

## Estructura a Generar

```
<proyecto>/
├── .agent/
│   ├── config.yaml
│   ├── commands/
│   │   ├── commit.md
│   │   └── test-module.md
│   ├── personas/
│   │   ├── code-reviewer.md
│   │   ├── security-auditor.md
│   │   └── tdd-enforcer.md
│   └── hooks/
│       └── pre-commit.md
├── docs/
│   ├── architecture/
│   │   ├── INDEX.md
│   │   └── 0001-stack-selection.md
│   └── invariants/
│       └── INVARIANTS.md
├── src/
│   └── <módulo-ejemplo>/
│       ├── AGENTS.md
│       ├── handler.<ext>
│       └── handler.test.<ext>
├── tests/
│   ├── integration/
│   │   └── .gitkeep
│   ├── fixtures/
│   │   └── .gitkeep
│   └── helpers/
│       └── .gitkeep
├── scripts/
│   └── .gitkeep
├── AGENTS.md
├── README.md
├── .gitignore
└── <archivo-config-proyecto>
```

---

## Plantillas por Archivo

### .agent/config.yaml

```yaml
version: "1.0"

project:
  name: "{NOMBRE_PROYECTO}"
  type: "{TIPO: web-application|api|library|cli|mobile}"
  primary_language: "{LENGUAJE}"
  
stack:
  runtime: "{RUNTIME_VERSION}"
  framework: "{FRAMEWORK_VERSION}"
  database: "{DATABASE_VERSION}"
  orm: "{ORM}"
  testing: "{TEST_FRAMEWORK}"

commands:
  build: "{COMANDO_BUILD}"
  test: "{COMANDO_TEST}"
  test_single: "{COMANDO_TEST_SINGLE}"
  lint: "{COMANDO_LINT}"
  format: "{COMANDO_FORMAT}"
  type_check: "{COMANDO_TYPES}"

paths:
  source: "src/"
  tests: "tests/"

conventions:
  naming:
    files: "{CONVENCIÓN_ARCHIVOS}"
    functions: "{CONVENCIÓN_FUNCIONES}"
    constants: "{CONVENCIÓN_CONSTANTES}"
  
  imports:
    order: ["{ORDEN_IMPORTS}"]

testing:
  tdd:
    required_for:
      - "src/**"
    recommended_for: []
    optional_for:
      - "scripts/**"
    
    thresholds:
      coverage_required: 80
      test_first_ratio: 80

boundaries:
  never_modify:
    - ".env*"
    - "*.lock"
    - "{ARCHIVOS_PROTEGIDOS}"
  
  ask_before_modifying:
    - "{CONFIG_PRINCIPAL}"
    - ".github/workflows/**"
    
  safe_to_modify:
    - "src/**"
    - "tests/**"

security:
  forbidden_patterns:
    - pattern: "{PATRÓN_PELIGROSO_1}"
      message: "{MENSAJE_1}"
```

### AGENTS.md (raíz)

```markdown
# AGENTS.md

> 🚀 **INICIO DE SESIÓN**
>
> Antes de cualquier tarea, ejecutar:
> ```bash
> git status --short && git log --oneline -1
> {COMANDO_TEST} 2>&1 | tail -3
> ```
> - Si hay cambios pendientes → informar al usuario
> - Si hay tests fallando → informar antes de empezar
> - Si la tarea es compleja o el proyecto es desconocido → ejecutar `/onboard`

## Identidad
{NOMBRE_PROYECTO}: {DESCRIPCIÓN_BREVE}
Stack: {STACK_RESUMIDO}

## Comandos
\`\`\`bash
{COMANDO_TEST}              # Todos los tests
{COMANDO_TEST_SINGLE}       # Test específico
{COMANDO_LINT}              # Verificar código
{COMANDO_FORMAT}            # Formatear código
\`\`\`

## Arquitectura
\`\`\`
src/
├── {MÓDULO}/       # {PROPÓSITO}
└── ...
\`\`\`

## Patrones

### Manejo de Errores
\`\`\`{LENGUAJE}
// ✅ Correcto: retornar resultado tipado
{EJEMPLO_ERROR_CORRECTO}

// ❌ Incorrecto: excepciones no controladas
{EJEMPLO_ERROR_INCORRECTO}
\`\`\`

### Acceso a Datos
\`\`\`{LENGUAJE}
// ✅ Correcto: usar cliente/repositorio centralizado
{EJEMPLO_DATOS_CORRECTO}

// ❌ Incorrecto: conexiones directas
{EJEMPLO_DATOS_INCORRECTO}
\`\`\`

## TDD Obligatorio

Para todo código en `src/`:
1. Escribir test primero
2. Verificar que falla
3. Implementar mínimo para que pase
4. Refactorizar

## Restricciones
- NUNCA commitear credenciales o .env
- NUNCA modificar {ARCHIVOS_CRÍTICOS} sin confirmación
- NUNCA eliminar tests que pasan

## Diagnóstico
1. Ejecutar `{COMANDO_LINT}`
2. Ejecutar `{COMANDO_TEST}`
3. Revisar `docs/architecture/` si hay dudas de diseño
```

### docs/architecture/INDEX.md

```markdown
# Decisiones Arquitectónicas

## Decisiones Activas

| ID | Tema | Impacto | Archivo |
|----|------|---------|---------|
| 0001 | Selección de stack | Alto | [0001-stack-selection.md](./0001-stack-selection.md) |

## Por Área
- **Stack**: 0001
```

### docs/architecture/0001-stack-selection.md

```markdown
# ADR-0001: Selección de Stack Tecnológico

## Estado
Aceptado | {FECHA}

## Contexto
{DESCRIPCIÓN_NECESIDAD}

## Decisión
Usamos:
- **Lenguaje**: {LENGUAJE} - {RAZÓN}
- **Framework**: {FRAMEWORK} - {RAZÓN}
- **Base de datos**: {DATABASE} - {RAZÓN}
- **Testing**: {TEST_FRAMEWORK} - {RAZÓN}

## Consecuencias

### Positivas
- {BENEFICIO_1}
- {BENEFICIO_2}

### Negativas
- {LIMITACIÓN_1}

### Restricciones para el Código
- {RESTRICCIÓN_1}
- {RESTRICCIÓN_2}

## Alternativas Consideradas
- **{ALTERNATIVA}**: {POR_QUÉ_NO}
```

### docs/invariants/INVARIANTS.md

```markdown
# Invariantes del Sistema

## Seguridad [CRÍTICO]

### INV-001: Validación de entrada obligatoria
Toda entrada externa DEBE validarse antes de procesarse.

### INV-002: Autenticación en endpoints protegidos
Todo endpoint que modifique datos DEBE verificar autenticación.

### INV-003: Sin credenciales en código
NUNCA hardcodear API keys, passwords o secrets en el código fuente.

## Datos [CRÍTICO]

### INV-004: Transacciones para operaciones múltiples
Operaciones que modifican múltiples registros DEBEN usar transacciones.

## Testing [OBLIGATORIO]

### INV-005: Tests para lógica de negocio
Todo archivo en `src/` DEBE tener test correspondiente.

### INV-006: Tests antes de implementación
En rutas TDD-obligatorias, el test DEBE existir antes del código.
```

### .agent/personas/tdd-enforcer.md

```markdown
---
name: tdd-enforcer
description: Verifica cumplimiento de TDD antes de implementar
trigger: before_file_create, before_file_modify
applies_to:
  - "src/**"
---

# TDD Enforcer

## Verificaciones

Antes de crear/modificar archivos en `src/`:

1. **¿Existe test?**
   - Archivo: `src/module/handler.{ext}`
   - Test esperado: `src/module/handler.test.{ext}`
   - Si NO existe → Crear test primero

2. **¿Test en rojo?**
   - Ejecutar test
   - Si PASA → Actualizar test para cubrir nuevo comportamiento
   - Si FALLA → Proceder con implementación

## Mensaje al Usuario

Si se detecta violación:

> ⚠️ **TDD Requerido**
>
> Antes de implementar `{archivo}`, necesito:
> 1. Crear test en `{archivo_test}`
> 2. Verificar que falla
> 3. Implementar
>
> ¿Procedo con este flujo?
```

### .agent/personas/code-reviewer.md

```markdown
---
name: code-reviewer
description: Revisa código por calidad, patrones y mejores prácticas
trigger: on_request
---

# Code Reviewer

## Checklist de Revisión

### Correctitud
- [ ] ¿La lógica es correcta?
- [ ] ¿Se manejan todos los casos de error?
- [ ] ¿Hay edge cases no cubiertos?

### Patrones
- [ ] ¿Sigue los patrones definidos en AGENTS.md?
- [ ] ¿Respeta las invariantes del sistema?
- [ ] ¿Usa los helpers/utilidades existentes?

### Testing
- [ ] ¿Tiene tests?
- [ ] ¿Los tests cubren casos de éxito y error?
- [ ] ¿Los tests son legibles?

### Mantenibilidad
- [ ] ¿Los nombres son descriptivos?
- [ ] ¿Las funciones tienen responsabilidad única?
- [ ] ¿Hay código duplicado que debería extraerse?

## Formato de Feedback

```
## Resumen
{resumen breve}

## Problemas
- 🔴 **Crítico**: {descripción}
- 🟠 **Importante**: {descripción}
- 🟡 **Sugerencia**: {descripción}

## Aprobación
{Aprobado | Requiere cambios | Bloqueado}
```
```

### .agent/personas/security-auditor.md

```markdown
---
name: security-auditor
description: Audita código por vulnerabilidades de seguridad
trigger: pre_commit
---

# Security Auditor

## Verificaciones

### Secrets
- [ ] ¿Hay API keys hardcodeadas?
- [ ] ¿Hay passwords en el código?
- [ ] ¿Se usan variables de entorno correctamente?

### Injection
- [ ] ¿Las queries usan parámetros/prepared statements?
- [ ] ¿Se sanitiza input para comandos del sistema?

### Autenticación
- [ ] ¿Los endpoints protegidos verifican auth?
- [ ] ¿Se validan permisos/roles?

### Validación
- [ ] ¿Se valida toda entrada externa?
- [ ] ¿Se validan tipos y rangos?

## Severidades

- 🔴 **CRÍTICO**: Bloquea commit (secrets, SQL injection)
- 🟠 **ALTO**: Requiere justificación
- 🟡 **MEDIO**: Warning
```

### .agent/commands/commit.md

```markdown
---
name: commit
description: Crear commit siguiendo convenciones
---

# Formato

```
<type>(<scope>): <description>

[body]

[footer]
```

## Tipos
- feat: Nueva funcionalidad
- fix: Corrección de bug
- refactor: Refactorización
- test: Tests
- docs: Documentación
- chore: Mantenimiento

## Proceso

1. Verificar que tests pasan
2. Ejecutar lint
3. Crear commit con mensaje descriptivo
4. Scope = módulo afectado
```

### .agent/commands/test-module.md

```markdown
---
name: test-module
description: Ejecuta tests de un módulo específico
---

# Uso

Cuando el usuario pida testear un módulo:

1. Identificar módulo
2. Ejecutar: `{COMANDO_TEST} src/{módulo}/`
3. Reportar resultados
4. Si hay fallos, ofrecer corregir
```

### README.md

```markdown
# {NOMBRE_PROYECTO}

{DESCRIPCIÓN}

## Stack

- **Lenguaje**: {LENGUAJE}
- **Framework**: {FRAMEWORK}
- **Base de datos**: {DATABASE}
- **Testing**: {TEST_FRAMEWORK}

## Desarrollo

### Requisitos
- {REQUISITO_1}
- {REQUISITO_2}

### Setup
\`\`\`bash
{COMANDOS_SETUP}
\`\`\`

### Comandos
\`\`\`bash
{COMANDO_BUILD}    # Build
{COMANDO_TEST}     # Tests
{COMANDO_LINT}     # Lint
\`\`\`

## Estructura

```
src/           # Código fuente (tests unitarios junto al código)
tests/         # Tests de integración y e2e
docs/          # Documentación
.agent/        # Configuración para agentes IA
```

## Documentación

- [Decisiones arquitectónicas](./docs/architecture/INDEX.md)
- [Invariantes del sistema](./docs/invariants/INVARIANTS.md)

---

## 🤖 AGENTIC-SPEC

Este proyecto sigue [AGENTIC-SPEC](https://github.com/...) v1.0, una especificación para repositorios optimizados para desarrollo con agentes de IA.

### ¿Qué significa esto?

El repositorio está estructurado para que agentes como Claude Code, Cursor, Copilot y otros puedan:

- **Orientarse rápidamente** leyendo `AGENTS.md`
- **Entender decisiones pasadas** consultando `docs/architecture/`
- **Respetar reglas inviolables** definidas en `docs/invariants/`
- **Seguir patrones consistentes** documentados con ejemplos
- **Trabajar con TDD** como metodología por defecto

### Archivos clave para agentes

| Archivo | Propósito |
|---------|-----------|
| `AGENTS.md` | Reglas, comandos y patrones del proyecto |
| `.agent/config.yaml` | Configuración estructurada (stack, comandos, límites) |
| `docs/architecture/` | ADRs - Por qué se tomaron las decisiones |
| `docs/invariants/` | Reglas que nunca deben violarse |
| `src/*/AGENTS.md` | Reglas específicas por módulo |

### Para humanos trabajando con agentes

1. **Antes de pedir cambios grandes**, asegúrate de que el agente ha leído `AGENTS.md`
2. **Si el agente hace algo incorrecto**, probablemente falta documentarlo en los patrones
3. **Las decisiones arquitectónicas** van en `docs/architecture/`, no en comentarios sueltos
4. **Los tests van primero** (TDD) - el agente está configurado para seguir este flujo

### Para contribuidores

Si modificas la arquitectura o añades patrones nuevos:

1. Crear ADR en `docs/architecture/` explicando el porqué
2. Actualizar `AGENTS.md` con ejemplos de código si aplica
3. Añadir invariantes en `docs/invariants/` si hay reglas nuevas
4. Los agentes futuros (y humanos) te lo agradecerán
```

### Módulo de Ejemplo

Crear un módulo básico que demuestre la estructura:

`src/<módulo>/AGENTS.md`:
```markdown
# Módulo: {MÓDULO}

## Propósito
{DESCRIPCIÓN_MÓDULO}

## Archivos
- `handler.{ext}`: Lógica principal
- `handler.test.{ext}`: Tests

## Patrones específicos
{PATRONES_DEL_MÓDULO}
```

`src/<módulo>/handler.{ext}`:
```
// Implementación mínima de ejemplo
// El agente debe expandir según necesidades
```

`src/<módulo>/handler.test.{ext}`:
```
// Test de ejemplo siguiendo TDD
// Estructura: describe > it > arrange/act/assert
```

---

## Mappings de Stack

### Python + FastAPI
```yaml
commands:
  build: "pip install -e ."
  test: "pytest"
  test_single: "pytest {file} -v"
  lint: "ruff check ."
  format: "ruff format ."
  type_check: "mypy src/"
conventions:
  naming:
    files: "snake_case"
    functions: "snake_case"
    constants: "SCREAMING_SNAKE_CASE"
```

### Go + Gin
```yaml
commands:
  build: "go build ./..."
  test: "go test ./..."
  test_single: "go test -v {file}"
  lint: "golangci-lint run"
  format: "gofmt -w ."
conventions:
  naming:
    files: "snake_case"
    functions: "camelCase"
    constants: "camelCase"
```

### TypeScript + Node
```yaml
commands:
  build: "npm run build"
  test: "npm test"
  test_single: "npm test -- {file}"
  lint: "npm run lint"
  format: "npm run format"
  type_check: "tsc --noEmit"
conventions:
  naming:
    files: "kebab-case"
    functions: "camelCase"
    constants: "SCREAMING_SNAKE_CASE"
```

### Rust
```yaml
commands:
  build: "cargo build"
  test: "cargo test"
  test_single: "cargo test {name}"
  lint: "cargo clippy"
  format: "cargo fmt"
conventions:
  naming:
    files: "snake_case"
    functions: "snake_case"
    constants: "SCREAMING_SNAKE_CASE"
```

### Java + Spring
```yaml
commands:
  build: "./gradlew build"
  test: "./gradlew test"
  test_single: "./gradlew test --tests {class}"
  lint: "./gradlew checkstyleMain"
  format: "./gradlew spotlessApply"
conventions:
  naming:
    files: "PascalCase"
    functions: "camelCase"
    constants: "SCREAMING_SNAKE_CASE"
```

---

## Proceso de Generación

1. **Recibir parámetros** (stack, dominio, nombre)
2. **Seleccionar mapping** según stack
3. **Crear directorios** en orden
4. **Generar archivos** sustituyendo placeholders
5. **Crear módulo de ejemplo** con test
6. **Verificar** estructura generada
7. **Reportar** archivos creados

## Output Esperado

```
✅ Proyecto {nombre} creado con AGENTIC-SPEC v1.0

Archivos generados:
- .agent/config.yaml
- .agent/commands/*.md
- .agent/personas/*.md
- docs/architecture/INDEX.md
- docs/architecture/0001-stack-selection.md
- docs/invariants/INVARIANTS.md
- src/{módulo}/handler.{ext}
- src/{módulo}/handler.test.{ext}
- AGENTS.md
- README.md
- .gitignore

Próximos pasos:
1. Revisar .agent/config.yaml y ajustar si necesario
2. Ejecutar `{comando_test}` para verificar setup
3. Comenzar desarrollo siguiendo TDD
```
