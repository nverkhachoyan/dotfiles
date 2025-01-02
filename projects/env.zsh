export load-env() {
    # Check for required dependencies
    if ! command -v op >/dev/null 2>&1; then
        echo "Error: 1Password CLI (op) is not installed. Please install it first."
        return 1
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo "Error: jq is not installed. Please install it first."
        return 1
    fi

    # Check 1Password authentication
    if ! op whoami &>/dev/null; then
        echo "Authenticating with 1Password..."
        eval $(op signin)
        if [ $? -ne 0 ]; then
            echo "Error: Failed to sign in to 1Password"
            return 1
        fi
    fi
    
    # Get list of all items
    echo "Fetching items from 1Password..."
    local items
    items=$(op item list --vault Development --format json 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch items from 1Password"
        return 1
    fi

    # Create menu of items
    echo "\nAvailable environment configurations:"
    local titles
    titles=($(echo "$items" | jq -r '.[].title'))
    
    select title in "${titles[@]}"; do
        if [ -n "$title" ]; then
            echo "\nLoading environment variables from $title..."
            local vars
            vars=$(op item get "$title" --vault Development --format json 2>/dev/null)
            
            while IFS='=' read -r key value; do
                if [ -n "$key" ] && [ -n "$value" ]; then
                    export "$key=$value"
                fi
            done < <(echo "$vars" | jq -r '.fields[] | select(.type=="STRING" and .purpose != "NOTES") | .label + "=" + .value')
            
            echo "Done! Environment variables from $title are loaded."
            break
        else
            echo "Invalid selection. Please try again."
        fi
    done
}