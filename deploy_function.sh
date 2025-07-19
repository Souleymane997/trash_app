#!/bin/bash

# Script pour déployer l'Edge Function Supabase

echo "🚀 Déploiement de l'Edge Function delete-user..."

# Vérifier si supabase CLI est installé
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI n'est pas installé. Installez-le avec: npm install -g supabase"
    exit 1
fi

# Se connecter à Supabase (si pas déjà connecté)
echo "🔐 Connexion à Supabase..."
supabase login

# Déployer l'Edge Function
echo "📦 Déploiement de la fonction delete-user..."
supabase functions deploy delete-user

echo "✅ Déploiement terminé!"
echo "🌐 URL de la fonction: https://your-project.supabase.co/functions/v1/delete-user" 