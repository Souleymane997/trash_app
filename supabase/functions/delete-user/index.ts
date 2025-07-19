import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Create a Supabase client with the Auth context of the function
    const supabaseClient = createClient(
      Deno.env.get('https://syjsibsbjickquqpvjae.supabase.co') ?? '',
      Deno.env.get('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5anNpYnNiamlja3F1cXB2amFlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NzcyNTMsImV4cCI6MjA2MzE1MzI1M30.iEUPHZB67TxiNo8x7E85jc_Aug9p9VTcVuR3WQJDo60') ?? '',
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } }
    )

    // Create a Supabase client with service role key for admin operations
    const supabaseAdmin = createClient(
      Deno.env.get('https://syjsibsbjickquqpvjae.supabase.co') ?? '',
      Deno.env.get('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN5anNpYnNiamlja3F1cXB2amFlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NzU3NzI1MywiZXhwIjoyMDYzMTUzMjUzfQ.1000000000000000000000000000000000000000') ?? ''
    )

    // Get the user making the request
    const { data: { user }, error: authError } = await supabaseClient.auth.getUser()
    
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: 'Non autorisé' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get the request body
    const { userId } = await req.json()

    if (!userId) {
      return new Response(
        JSON.stringify({ error: 'ID utilisateur requis' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if the current user is an admin
    const { data: userRole, error: roleError } = await supabaseAdmin
      .from('users')
      .select('role_id')
      .eq('id', user.id)
      .single()

    if (roleError || userRole?.role_id !== 4) { // Assuming 1 = admin
      return new Response(
        JSON.stringify({ error: 'Accès refusé - Admin requis' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Delete the user from Supabase Auth
    const { error: deleteAuthError } = await supabaseAdmin.auth.admin.deleteUser(userId)
    
    if (deleteAuthError) {
      return new Response(
        JSON.stringify({ error: `Erreur lors de la suppression: ${deleteAuthError.message}` }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Delete user data from your tables
    await supabaseAdmin.from('users').delete().eq('id', userId)
    // Add other table deletions as needed (abonnements, etc.)

    return new Response(
      JSON.stringify({ success: true, message: 'Utilisateur supprimé avec succès' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: `Erreur serveur: ${error.message}` }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
}) 