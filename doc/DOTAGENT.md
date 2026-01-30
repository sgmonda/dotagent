# DOTAGENT v1.0

## Especificación para Repositorios Gestionados por Agentes de IA

---

## Prólogo: El Cambio de Paradigma

Durante décadas, las prácticas de desarrollo de software han optimizado para un lector específico: el cerebro humano. Clean code, SOLID, DRY, patrones de diseño... todo asume un desarrollador con memoria a largo plazo, intuición, contexto implícito y la capacidad de "leer entre líneas".

Los agentes de IA operan bajo restricciones radicalmente diferentes:

| Humano | Agente |
|--------|--------|
| Memoria persistente entre sesiones | Sin memoria entre sesiones |
| Contexto implícito acumulado | Solo conoce lo que está escrito |
| Intuición para inferir intenciones | Requiere especificación explícita |
| Coste cognitivo al repetir trabajo | Puede regenerar código trivial sin coste |
| Limitado por tiempo y fatiga | Limitado por tokens y contexto |

Esta especificación define cómo estructurar repositorios que maximicen la efectividad de agentes como Claude Code, Cursor, Copilot, Aider y otros, sin sacrificar la mantenibilidad humana.

---

## 1. Estructura de Directorios

### 1.1 Raíz del Proyecto

```
proyecto/
├── .agent/                    # Configuración para agentes (ver sección 2)
├── docs/
│   ├── architecture/          # ADRs y documentación arquitectónica
│   ├── invariants/            # Invariantes del sistema
│   └── runbooks/              # Procedimientos operativos
├── src/                       # Código fuente
├── tests/                     # Tests de integración y e2e
├── scripts/                   # Scripts de automatización
├── AGENTS.md                  # Instrucciones principales para agentes
├── README.md                  # Documentación para humanos
└── CHANGELOG.md               # Historial de cambios
```

### 1.2 Principio de Localidad

Los agentes operan mejor cuando el contexto relevante está cerca del código que modifican. Cada directorio significativo puede contener:

```
src/payments/
├── AGENTS.md                  # Reglas específicas de este módulo
├── INVARIANTS.md              # Invariantes que nunca deben violarse
├── handlers/
├── models/
└── *.test.*                   # Tests unitarios junto al código
```

El agente lee el `AGENTS.md` más cercano al archivo que está modificando, permitiendo reglas jerárquicas que se sobrescriben de general a específico.

---

## 2. El Directorio `.agent/`

Configuración dedicada para agentes de IA:

```
.agent/
├── config.yaml                # Configuración global del proyecto
├── commands/                  # Slash commands personalizados
│   ├── deploy.md
│   ├── test-module.md
│   └── review.md
├── skills/                    # Conocimiento especializado
│   ├── database/SKILL.md
│   ├── authentication/SKILL.md
│   └── api-design/SKILL.md
├── personas/                  # Agentes especializados
│   ├── code-reviewer.md
│   ├── security-auditor.md
│   └── tdd-enforcer.md
└── hooks/                     # Automatizaciones
    ├── pre-commit.md
    └── post-change.md
```

### 2.1 Archivo de Configuración Principal

El archivo `.agent/config.yaml` define la configuración del proyecto de forma estructurada:

```yaml
version: "1.0"

project:
  name: "<nombre del proyecto>"
  type: "<web-application|api|library|cli|mobile|other>"
  primary_language: "<lenguaje principal>"
  
stack:
  # Definir las tecnologías del proyecto
  runtime: "<runtime y versión>"
  framework: "<framework y versión>"
  database: "<base de datos si aplica>"
  orm: "<ORM/query builder si aplica>"
  testing: "<framework de testing>"

commands:
  # Comandos que el agente puede ejecutar
  build: "<comando de build>"
  test: "<comando para ejecutar tests>"
  test_single: "<comando para test individual con placeholder {file}>"
  lint: "<comando de linting>"
  format: "<comando de formateo>"
  type_check: "<comando de verificación de tipos si aplica>"

paths:
  # Ubicaciones importantes del proyecto
  source: "<directorio de código fuente>"
  tests: "<directorio de tests de integración/e2e>"
  # Agregar paths específicos del proyecto
  
conventions:
  naming:
    files: "<kebab-case|snake_case|camelCase>"
    components: "<PascalCase|camelCase>"
    functions: "<camelCase|snake_case>"
    constants: "<SCREAMING_SNAKE_CASE|camelCase>"
  
  imports:
    order: ["<categorías en orden de prioridad>"]
    alias: "<alias de imports si existe>"
    
boundaries:
  never_modify:
    # Archivos que NUNCA deben modificarse sin intervención humana
    - ".env*"
    - "*.lock"
    - "<archivos de migración>"
  
  ask_before_modifying:
    # Archivos que requieren confirmación
    - "<archivos de configuración críticos>"
    - "<workflows de CI/CD>"
    
  safe_to_modify:
    # Patrones de archivos seguros para modificar
    - "src/**/*.<extensión>"
    - "tests/**/*.test.*"
```

---

## 3. AGENTS.md: La Constitución del Proyecto

El archivo `AGENTS.md` es el documento más crítico. Es lo que el agente lee al inicio de cada sesión.

### 3.1 Principios de Redacción

1. **Concisión extrema**: Cada instrucción consume tokens. Elimina redundancias.
2. **Instrucciones positivas**: "Usa X" es mejor que "No uses Y" (los agentes ignoran negaciones con mayor frecuencia).
3. **Ejemplos sobre explicaciones**: Mostrar código correcto > describir qué hacer.
4. **Priorización visual**: Lo más importante primero.

### 3.2 Estructura Recomendada

```markdown
# AGENTS.md

> 🚀 **INICIO DE SESIÓN**
>
> Antes de cualquier tarea, ejecutar:
> ```bash
> git status --short && git log --oneline -1
> ```
> - Si hay cambios pendientes → informar al usuario
> - Si hay tests fallando → informar antes de empezar
> - Si la tarea es compleja o el proyecto es desconocido → ejecutar onboarding completo

## Identidad del Proyecto
<Descripción breve: qué es, stack principal>

## Comandos Críticos
```bash
<comando test>           # Ejecutar todos los tests
<comando test único>     # Test específico
<comando verificación>   # Verificar tipos/lint
<otros comandos clave>
```

## Arquitectura
```
src/
├── <carpeta>/     # <propósito>
├── <carpeta>/     # <propósito>
└── <carpeta>/     # <propósito>
```

## Patrones Obligatorios

### <Área 1: ej. Acceso a Datos>
```<lenguaje>
// ✅ Correcto: <descripción>
<código correcto>

// ❌ Incorrecto: <descripción>
<código incorrecto>
```

### <Área 2: ej. Manejo de Errores>
```<lenguaje>
// ✅ Correcto
<código correcto>

// ❌ Incorrecto
<código incorrecto>
```

## Restricciones Absolutas
- NUNCA <acción prohibida 1>
- NUNCA <acción prohibida 2>
- NUNCA <acción prohibida 3>

## Cuando Algo Falla
1. <Paso de diagnóstico 1>
2. <Paso de diagnóstico 2>
3. Revisar `docs/architecture/` para entender decisiones previas
```

### 3.3 Anti-patrones a Evitar

| Anti-patrón | Por qué es malo | Alternativa |
|-------------|-----------------|-------------|
| Guías de estilo extensas | Usa tokens, el linter lo hace mejor | Configura herramientas de linting |
| "Nunca hagas X" sin alternativa | El agente queda bloqueado | "Prefiere Y sobre X" |
| Documentar lo obvio | Desperdicia contexto | Solo documenta excepciones |
| AGENTS.md > 2000 tokens | Degrada calidad de respuestas | Divide en archivos por módulo |

---

## 4. Architecture Decision Records (ADRs)

Los ADRs son críticos para agentes porque capturan el **porqué** detrás de las decisiones, información que no existe en el código.

### 4.1 Ubicación y Formato

```
docs/architecture/
├── INDEX.md                          # Índice de decisiones
├── 0001-<decisión-1>.md
├── 0002-<decisión-2>.md
├── 0003-<decisión-3>.md
└── template.md
```

### 4.2 Plantilla Optimizada para Agentes

```markdown
# ADR-<número>: <Título de la decisión>

## Estado
<Propuesto|Aceptado|Deprecado|Sustituido> | <fecha>

## Contexto
<Descripción del problema o necesidad que motiva la decisión>

## Decisión
<La decisión tomada, en términos claros>

## Consecuencias

### Positivas
- <Beneficio 1>
- <Beneficio 2>

### Negativas
- <Coste o limitación 1>
- <Coste o limitación 2>

### Restricciones para el Código
- <Regla que debe seguirse en el código>
- <Patrón obligatorio>
- <Patrón prohibido>

## Alternativas Consideradas
- **<Alternativa 1>**: <Por qué se descartó>
- **<Alternativa 2>**: <Por qué se descartó>
```

### 4.3 Índice de ADRs para Agentes

Mantener un índice que el agente pueda consultar rápidamente:

```markdown
# docs/architecture/INDEX.md

## Decisiones Activas

| ID | Tema | Impacto | Archivo |
|----|------|---------|---------|
| 0001 | <Tema> | Alto | [0001-tema.md](./0001-tema.md) |
| 0002 | <Tema> | Alto | [0002-tema.md](./0002-tema.md) |

## Búsqueda por Área
- **Frontend**: 0001, 0005, 0008
- **Base de datos**: 0002, 0006
- **Infraestructura**: 0004, 0007
```

---

## 5. Invariantes del Sistema

Las invariantes son reglas que **nunca deben violarse**. Son especialmente importantes para agentes porque definen límites duros.

### 5.1 Archivo de Invariantes Global

`docs/invariants/INVARIANTS.md`:

```markdown
# Invariantes del Sistema

## Seguridad [CRÍTICO]

### INV-001: <Nombre de la invariante>
<Descripción de la regla>
```<lenguaje>
// ✅ Correcto
<código que cumple la invariante>

// ❌ Viola invariante
<código que viola la invariante>
```

### INV-002: <Nombre de la invariante>
<Descripción de la regla>

## Consistencia de Datos [CRÍTICO]

### INV-003: <Nombre de la invariante>
<Descripción de la regla>

## Testing [OBLIGATORIO]

### INV-004: <Nombre de la invariante>
<Descripción de la regla>
```

### 5.2 Invariantes por Módulo

Cada módulo crítico puede tener sus propias invariantes:

```markdown
# src/<módulo>/INVARIANTS.md

## <MÓDULO>-001: <Nombre>
<Descripción y ejemplos de código>

## <MÓDULO>-002: <Nombre>
<Descripción y ejemplos de código>
```

---

## 6. Metadatos de Dependencias

Los agentes necesitan entender las relaciones entre módulos para hacer cambios coherentes.

### 6.1 Grafo de Dependencias

`docs/architecture/dependencies.yaml`:

```yaml
modules:
  <módulo-1>:
    path: "src/<módulo-1>/"
    depends_on: ["<módulo-2>"]
    depended_by: ["<módulo-3>", "<módulo-4>"]
    exports:
      - "<función o clase exportada>"
    
  <módulo-2>:
    path: "src/<módulo-2>/"
    depends_on: ["<módulo-1>"]
    depended_by: ["<módulo-5>"]
    external_dependencies:
      - name: "<librería externa>"
        version: "<versión>"
        docs: "<URL de documentación>"

change_impact:
  # Si cambias X, revisa Y
  "<archivo o patrón>":
    - "<acción requerida 1>"
    - "<acción requerida 2>"
```

### 6.2 Mapa de Impacto

Para cambios de alto riesgo, documentar explícitamente qué puede romperse:

```markdown
# docs/architecture/impact-map.md

## Cambios en <Área Crítica>

### <Tipo de cambio 1>
1. <Paso requerido>
2. <Paso requerido>
3. <Verificación>

### <Tipo de cambio 2>
⚠️ REQUIERE <precaución especial>
1. <Paso requerido>
2. <Paso requerido>
```

---

## 7. Documentación Ejecutable

Código que se documenta a sí mismo y puede verificarse automáticamente.

### 7.1 Contratos Verificables

Usar el sistema de validación del lenguaje/framework para definir contratos:

```
// Ejemplo conceptual - adaptar al stack específico

/**
 * Contrato: <NombreOperación>
 * 
 * @invariant <Regla que debe cumplirse>
 * @invariant <Otra regla>
 */
<definición del schema/tipo con validaciones>
```

### 7.2 Ejemplos como Especificación

```
// src/<módulo>/examples.<extensión>

/**
 * Ejemplos canónicos para el módulo.
 * Estos ejemplos son ejecutados como tests y sirven como documentación.
 */

export const examples = {
  /** <Descripción del caso> */
  <nombreCaso>: {
    input: { /* datos de entrada */ },
    expectedOutput: { /* resultado esperado */ }
  },
  
  /** <Descripción de otro caso> */
  <otroCaso>: {
    input: { /* datos de entrada */ },
    expectedOutput: { /* resultado esperado */ }
  }
}
```

---

## 8. Testing para Agentes

Los tests son el mecanismo de verificación principal. Sin tests, el agente opera a ciegas.

### 8.1 Estructura de Tests: Colocación Híbrida

Los tests unitarios van **junto al código que prueban**. Los tests de integración y e2e van en directorio separado.

#### Por qué tests unitarios junto al código

| Beneficio | Impacto para el agente |
|-----------|------------------------|
| Localidad | Ve test + código en un solo listado de directorio |
| Descubrimiento | Imposible ignorar que existe el test |
| Refactoring | Mover archivo = mover test automáticamente |
| Contexto | Test y código comparten tokens de contexto cercanos |

#### Estructura recomendada

```
src/
├── <módulo-1>/
│   ├── handler.<ext>
│   ├── handler.test.<ext>        # ✅ Unit test junto al código
│   ├── service.<ext>
│   ├── service.test.<ext>        # ✅ Unit test junto al código
│   └── types.<ext>
├── <módulo-2>/
│   ├── client.<ext>
│   ├── client.test.<ext>         # ✅ Unit test junto al código
│   └── utils.<ext>

tests/
├── integration/                   # Tests que cruzan módulos
│   ├── <flujo-1>.test.<ext>
│   └── <flujo-2>.test.<ext>
├── e2e/                           # Tests de sistema completo
│   ├── <escenario-1>.test.<ext>
│   └── <escenario-2>.test.<ext>
├── fixtures/                      # Datos de prueba compartidos
│   └── <entidad>.fixtures.<ext>
└── helpers/                       # Utilidades de testing
    └── <helper>.<ext>
```

#### Configuración

Excluir tests del build de producción y configurar el test runner para encontrar tests en ambas ubicaciones:

```yaml
# Pseudo-configuración - adaptar al stack
test:
  include:
    - "src/**/*.test.*"        # Unit tests junto al código
    - "tests/**/*.test.*"      # Integration/e2e tests
  exclude:
    - "node_modules"
    - "dist"
    - "build"

build:
  exclude:
    - "**/*.test.*"
```

### 8.2 Convenciones para Tests Amigables con Agentes

```
// src/<módulo>/<archivo>.test.<ext>

/**
 * Tests para <función/módulo>
 * 
 * @module <módulo>
 * @function <función>
 * @dependencies <dependencias>
 */
describe("<función/módulo>", () => {
  // ============================================
  // SETUP - Contexto compartido
  // ============================================
  // Preparación de datos y mocks

  // ============================================
  // CASOS EXITOSOS
  // ============================================
  describe("cuando los datos son válidos", () => {
    it("<descripción del comportamiento esperado>", () => {
      // Arrange - datos de entrada
      // Act - ejecutar función
      // Assert - verificar resultado
    })
  })

  // ============================================
  // CASOS DE ERROR
  // ============================================
  describe("cuando los datos son inválidos", () => {
    it("<descripción del error esperado>", () => {
      // Arrange, Act, Assert
    })
  })

  // ============================================
  // CASOS LÍMITE
  // ============================================
  describe("casos límite", () => {
    it("<descripción del caso límite>", () => {
      // Arrange, Act, Assert
    })
  })
})
```

### 8.3 Indicadores para el Agente

Agregar metadatos que ayuden al agente a entender qué tests ejecutar:

```
/**
 * @tags critical, <área>
 * @runWith <comando para ejecutar estos tests>
 * @relatedFiles <archivos relacionados>
 * @runBefore <comandos de setup si son necesarios>
 */
```

---

## 9. Test-Driven Development (TDD)

Los agentes operan mejor con contratos verificables definidos *antes* de implementar. TDD no es solo una buena práctica: es el mecanismo que ancla el razonamiento del agente y previene alucinaciones funcionales.

### 9.1 Por Qué TDD es Crítico para Agentes

| Sin TDD | Con TDD |
|---------|---------|
| El agente implementa y "espera que funcione" | El agente sabe exactamente qué debe pasar |
| Errores se descubren tarde o nunca | Feedback inmediato en cada ciclo |
| Tests escritos después justifican el código | Tests escritos antes especifican el comportamiento |
| El agente puede alucinar comportamientos | El test ancla la realidad esperada |

### 9.2 Niveles de Obligatoriedad

No todo código requiere TDD estricto. Definir niveles según el riesgo:

```yaml
# .agent/config.yaml

testing:
  tdd:
    # Nivel 1: OBLIGATORIO - tests antes de implementar
    required_for:
      - "src/<lógica-negocio>/**"
      - "src/<utilidades-compartidas>/**"
      - "src/<dominio>/**"
    
    # Nivel 2: RECOMENDADO - tests antes salvo justificación
    recommended_for:
      - "src/<componentes>/**"
      - "src/<hooks-o-helpers>/**"
    
    # Nivel 3: OPCIONAL - tests después o ninguno
    optional_for:
      - "src/<páginas-o-vistas>/**"
      - "scripts/**"
      - "**/*.config.*"
```

### 9.3 El Ciclo TDD para Agentes

Documentar el ciclo explícitamente en `AGENTS.md`:

```markdown
## Testing: TDD por Defecto

Para archivos en rutas TDD-obligatorias:

### Ciclo Obligatorio

1. **TEST PRIMERO**: Escribe el test describiendo el comportamiento esperado
2. **ROJO**: Ejecuta el test - DEBE fallar
3. **IMPLEMENTA**: Escribe el mínimo código para que pase
4. **VERDE**: Ejecuta el test - DEBE pasar
5. **REFACTORIZA**: Mejora el código manteniendo tests verdes
6. **REPITE**: Siguiente caso de prueba

### Excepciones Permitidas

Puedes omitir TDD estricto si:
- Es un **spike exploratorio** → Marcar con `// SPIKE: eliminar o testear antes de merge`
- Es **configuración pura** sin lógica condicional
- El usuario **explícitamente lo solicita** con justificación
- Es **código generado** automáticamente
```

### 9.4 Enforcement Automático

#### Persona TDD Enforcer

`.agent/personas/tdd-enforcer.md`:

```markdown
---
name: tdd-enforcer
description: Verifica cumplimiento de TDD antes de implementar
trigger: before_file_create, before_file_modify
applies_to: <rutas TDD-obligatorias>
---

# TDD Enforcer

Antes de crear o modificar archivos en rutas TDD-obligatorias:

## Verificaciones

1. **¿Existe test correspondiente?**
   - Si NO existe → Crear test primero

2. **¿El test cubre el cambio planeado?**
   - Si es función nueva → Test debe existir y fallar
   - Si es modificación → Test debe cubrir el caso modificado

3. **¿El test está en rojo?**
   - Si PASA → El test no especifica el nuevo comportamiento
   - Si FALLA → Proceder con implementación

## Flujo de Decisión

```
¿Archivo en ruta TDD-obligatoria?
    │
    ├─ NO → Proceder normalmente
    │
    └─ SÍ → ¿Existe test correspondiente?
              │
              ├─ NO → CREAR TEST PRIMERO
              │        └─ Ejecutar test (debe fallar)
              │             └─ Implementar
              │
              └─ SÍ → ¿Test cubre el cambio?
                        │
                        ├─ NO → ACTUALIZAR TEST PRIMERO
                        │
                        └─ SÍ → Implementar y verificar
```
```

### 9.5 Métricas TDD

```yaml
# .agent/config.yaml

testing:
  tdd:
    metrics:
      track: true
      report_path: ".agent/logs/tdd-metrics.md"
      
    thresholds:
      # Porcentaje mínimo de archivos TDD-obligatorios con tests
      coverage_required: 95
      # Tests deben existir antes del código (medido por timestamps en git)
      test_first_ratio: 80
```

---

## 10. Comandos y Scripts

### 10.1 Scripts Documentados

Definir comandos estándar que el agente pueda usar:

```yaml
# Ejemplo de estructura en package.json, Makefile, o equivalente

commands:
  dev: "<iniciar desarrollo>"
  build: "<compilar para producción>"
  test: "<ejecutar todos los tests>"
  test:unit: "<ejecutar tests unitarios>"
  test:integration: "<ejecutar tests de integración>"
  test:e2e: "<ejecutar tests end-to-end>"
  lint: "<verificar estilo de código>"
  lint:fix: "<corregir estilo automáticamente>"
  format: "<formatear código>"
  type-check: "<verificar tipos si aplica>"
  validate: "<lint + types + test combinados>"
```

### 10.2 Slash Commands Personalizados

`.agent/commands/test-module.md`:

```markdown
---
name: test-module
description: Ejecuta tests de un módulo específico
---

# Instrucciones

Cuando el usuario pida testear un módulo:

1. Identificar el módulo
2. Ejecutar tests unitarios: `<comando> src/{módulo}/**/*.test.*`
3. Si hay fallos, analizar y corregir
4. Ejecutar tests de integración relacionados
5. Reportar resultados
```

---

## 11. Control de Versiones para Agentes

### 11.1 Convención de Commits

`.agent/commands/commit.md`:

```markdown
---
name: commit
description: Crear commit siguiendo convenciones
---

# Formato de Commit

```
<type>(<scope>): <description>

[body]

[footer]
```

## Tipos
- feat: Nueva funcionalidad
- fix: Corrección de bug
- refactor: Refactorización sin cambio funcional
- test: Agregar o modificar tests
- docs: Documentación
- chore: Mantenimiento

## Ejemplo

```
feat(orders): add discount validation

- Validate discount codes against database
- Check expiration and usage limits
- Return clear error messages

Closes #123
```
```

### 11.2 Branching Strategy

```markdown
# docs/architecture/git-workflow.md

## Ramas

- `main`: Producción, siempre deployable
- `develop`: Integración (si se usa GitFlow)
- `feature/*`: Nuevas funcionalidades
- `fix/*`: Correcciones

## Flujo para Agentes

1. Crear rama desde base: `git checkout -b feature/<ticket>-<descripción>`
2. Hacer cambios incrementales con commits atómicos
3. Ejecutar validación antes de cada commit
4. Crear PR cuando esté listo
```

---

## 12. Seguridad y Límites

### 12.1 Archivos Protegidos

```yaml
# .agent/config.yaml

security:
  # Archivos que NUNCA deben modificarse sin confirmación humana
  protected_files:
    - ".env*"
    - "*.pem"
    - "*.key"
    - "<directorio de migraciones>/**"
    - "<workflows de CI/CD>/**"
    - "<archivos de lock>"
  
  # Patrones que nunca deben aparecer en el código
  forbidden_patterns:
    - pattern: "<patrón peligroso 1>"
      message: "<explicación>"
    - pattern: "<patrón peligroso 2>"
      message: "<explicación>"
  
  # Límites operativos
  limits:
    max_file_changes_per_commit: 20
    max_lines_per_file: 500
    require_tests_for: ["<rutas críticas>"]
```

### 12.2 Revisión de Seguridad Automática

`.agent/personas/security-auditor.md`:

```markdown
---
name: security-auditor
description: Revisa cambios por vulnerabilidades de seguridad
trigger: pre-commit
---

# Security Auditor

Antes de cada commit, verificar:

## Checklist

1. **Secrets**: ¿Hay credenciales hardcodeadas?
2. **Injection**: ¿Las queries usan parámetros?
3. **XSS**: ¿El input de usuario se sanitiza?
4. **Auth**: ¿Las rutas protegidas verifican autenticación?
5. **Validation**: ¿Toda entrada externa se valida?

## Severidades

- 🔴 CRÍTICO: Bloquea el commit
- 🟠 ALTO: Requiere justificación
- 🟡 MEDIO: Warning, proceder con cautela
```

---

## 13. Monitoreo y Feedback

### 13.1 Logging de Sesiones

```yaml
# .agent/config.yaml

feedback:
  log_sessions: true
  log_path: ".agent/logs/"
  
  # Patrones de error comunes para documentar
  common_errors:
    - pattern: "<error frecuente 1>"
      solution: "<solución>"
    - pattern: "<error frecuente 2>"
      solution: "<solución>"
```

### 13.2 Métricas de Efectividad

```markdown
# .agent/logs/metrics.md

## Última semana

| Métrica | Valor |
|---------|-------|
| Tareas completadas | X |
| Commits exitosos | X |
| Tests agregados | X |
| Bugs introducidos | X |

## Errores frecuentes
1. <Error 1> (X ocurrencias)
2. <Error 2> (X ocurrencias)

## Mejoras sugeridas
- <Mejora basada en errores detectados>
```

---

## 14. Checklist de Implementación

### 14.1 Mínimo Viable (Día 1)

- [ ] Crear `AGENTS.md` con comandos básicos y patrones
- [ ] Documentar stack tecnológico
- [ ] Listar archivos protegidos
- [ ] Agregar ejemplos de código correcto vs incorrecto
- [ ] Definir rutas TDD-obligatorias en config

### 14.2 Fundamentos (Semana 1)

- [ ] Crear estructura `.agent/`
- [ ] Escribir 3-5 ADRs para decisiones principales
- [ ] Documentar invariantes críticas
- [ ] Configurar slash commands básicos
- [ ] Documentar ciclo TDD en AGENTS.md
- [ ] Crear persona `tdd-enforcer`

### 14.3 Optimización (Mes 1)

- [ ] Agregar AGENTS.md por módulo
- [ ] Crear personas especializadas
- [ ] Documentar grafo de dependencias
- [ ] Implementar métricas de efectividad
- [ ] Configurar hook pre-commit para TDD
- [ ] Establecer métricas de cumplimiento TDD

### 14.4 Madurez (Trimestre 1)

- [ ] Tests como especificación ejecutable
- [ ] Hooks de pre-commit automatizados
- [ ] Feedback loop de mejora continua
- [ ] Documentación generada automáticamente
- [ ] 95%+ cumplimiento TDD sostenido

---

## 15. Ejemplo Completo

Repositorio de referencia con esta especificación implementada:

```
example-agentic-repo/
├── .agent/
│   ├── config.yaml
│   ├── commands/
│   │   ├── commit.md
│   │   ├── test-module.md
│   │   └── deploy.md
│   ├── skills/
│   │   └── <área>/SKILL.md
│   ├── personas/
│   │   ├── code-reviewer.md
│   │   ├── security-auditor.md
│   │   └── tdd-enforcer.md
│   ├── hooks/
│   │   └── pre-commit-tdd.md
│   └── logs/
│       └── tdd-metrics.md
├── docs/
│   ├── architecture/
│   │   ├── INDEX.md
│   │   ├── 0001-<decisión>.md
│   │   ├── 0002-<decisión>.md
│   │   └── dependencies.yaml
│   └── invariants/
│       ├── INVARIANTS.md
│       └── <módulo>.invariants.md
├── src/
│   ├── <módulo-1>/
│   │   ├── AGENTS.md
│   │   ├── INVARIANTS.md
│   │   ├── handler.ext
│   │   ├── handler.test.ext
│   │   └── examples.ext
│   └── <módulo-2>/
│       ├── AGENTS.md
│       └── ...
├── tests/
│   ├── integration/
│   ├── e2e/
│   └── fixtures/
├── AGENTS.md
├── README.md
└── <config de proyecto>
```

---

## Apéndice A: Glosario

| Término | Definición |
|---------|------------|
| **ADR** | Architecture Decision Record. Documento que captura una decisión arquitectónica y su contexto. |
| **Invariante** | Condición que debe mantenerse verdadera en todo momento del sistema. |
| **Slash Command** | Comando personalizado invocable con `/nombre` en agentes. |
| **Skill** | Conocimiento especializado empaquetado para un agente. |
| **Persona** | Configuración que da al agente un rol especializado. |
| **Token** | Unidad de texto procesada por el modelo (~4 caracteres). |
| **Contexto** | Información disponible para el agente en una sesión. |
| **TDD** | Test-Driven Development. Escribir tests antes de implementar. |

---

## Apéndice B: Recursos

- [AGENTS.md Standard](https://agentsmd.io)
- [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Architecture Decision Records](https://adr.github.io/)
- [Awesome Claude Code](https://github.com/hesreallyhim/awesome-claude-code)

---

## Apéndice C: Ejemplo de Implementación

Para ver un ejemplo concreto de esta especificación aplicada a un stack específico (TypeScript + Node.js), consulta el repositorio de referencia o solicita la generación de una plantilla para tu stack particular.

---

## Historial de Versiones

| Versión | Fecha | Cambios |
|---------|-------|---------|
| 1.0 | 2026-01-30 | Versión inicial (agnóstica de stack) |

---

*Esta especificación está diseñada para ser adaptada a cualquier stack tecnológico. Los principios son universales; los detalles de implementación varían según el lenguaje y framework.*
