output "aad_users" {
    value = {
        for user in data.azuread_user.aad_users: 
            user.id => user.display_name
    }
}