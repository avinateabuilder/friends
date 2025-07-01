/** @type {import('tailwindcss').Config} */
export default {
  content: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  theme: {
    extend: {
      backgroundImage: {
        'brasas-bg': "url('/fondo.jpg')",
      },
      colors: {
        // Paleta de brasas/lava incandescente
        'ember-orange': '#FF4500',      // Naranja fuego intenso
        'lava-red': '#FF2500',          // Rojo lava
        'flame-yellow': '#FFB000',      // Amarillo llama
        'magma-orange': '#FF6B35',      // Naranja magma
        'fire-core': '#FF8C42',         // Núcleo de fuego
        'molten-gold': '#FFA500',       // Oro fundido
        'ember-glow': '#FF7F50',        // Brillo de brasas
        'cyber-black': '#000000',
        'cyber-white': '#FFFFFF',
        'cyber-gray': '#1A1A1A',
        'cyber-dark': '#0A0A0A',
      },
      fontFamily: {
        'cyber': ['Montserrat', 'sans-serif'],
        'body': ['Inter', 'sans-serif'],
      },
      animation: {
        'glow': 'glow 2s ease-in-out infinite alternate',
        'pulse-neon': 'pulse-neon 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'float': 'float 3s ease-in-out infinite',
        'gradient': 'gradient 3s ease infinite',
      },
      keyframes: {
        glow: {
          '0%': { 
            textShadow: '0 0 5px #FF4500, 0 0 10px #FF4500, 0 0 15px #FF4500',
            boxShadow: '0 0 5px #FF4500'
          },
          '100%': { 
            textShadow: '0 0 10px #FF4500, 0 0 20px #FF4500, 0 0 30px #FF4500',
            boxShadow: '0 0 10px #FF4500, 0 0 20px #FF4500'
          }
        },
        'pulse-neon': {
          '0%, 100%': { 
            boxShadow: '0 0 5px #FF2500, 0 0 10px #FF2500, 0 0 15px #FF2500',
            borderColor: '#FF2500'
          },
          '50%': { 
            boxShadow: '0 0 10px #FF2500, 0 0 20px #FF2500, 0 0 30px #FF2500',
            borderColor: '#FF2500'
          }
        },
        float: {
          '0%, 100%': { transform: 'translateY(0px)' },
          '50%': { transform: 'translateY(-10px)' }
        },
        gradient: {
          '0%, 100%': { backgroundPosition: '0% 50%' },
          '50%': { backgroundPosition: '100% 50%' }
        }
      },
      backgroundImage: {
        'cyber-gradient': 'linear-gradient(45deg, #FF00FF, #00FFFF, #00FF00)',
        'cyber-gradient-dark': 'linear-gradient(135deg, #000000 0%, #1A1A1A 100%)',
      },
      backgroundSize: {
        '200%': '200% 200%',
      },
      dropShadow: {
        'glow': '0 0 10px #FF4500, 0 0 20px #FF4500, 0 0 30px #FF4500'
      }
    },
  },
  plugins: [],
};