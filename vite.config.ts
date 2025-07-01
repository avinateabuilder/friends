import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  optimizeDeps: {
    exclude: ['lucide-react'],
    include: ['sql.js']
  },
  server: {
    fs: {
      allow: ['..']
    }
  },
  build: {
    rollupOptions: {
      external: [],
      output: {
        manualChunks: {
          'sql.js': ['sql.js']
        }
      }
    }
  },
  define: {
    global: 'globalThis'
  }
});