export load-kater() {
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
    
    local vars
    vars=$(op item get Kater --vault Development --format json 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch Kater item from 1Password"
        return 1
    fi

    while IFS='=' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ]; then
            export "$key=$value"
        fi
    done < <(echo "$vars" | jq -r '.fields[] | select(.type=="STRING" and .purpose != "NOTES") | .label + "=" + .value')
    
    echo "Done! Kater environment variables are loaded."
}