/*
 * Tipos de las variables de entorno.
 * Sin esto, TypeScript no sabe que existe import.meta.env.VITE_DEV_OPEN_LOGIN
 * y no te avisaría si lo escribes mal (ej: VITE_DEV_OPEN_LOGN).
 * "interface" aquí AMPLÍA la que ya trae Vite (declaration merging).
 */
interface ImportMetaEnv {
    readonly VITE_DEV_OPEN_LOGIN?: 'true' | 'false';
  }
  