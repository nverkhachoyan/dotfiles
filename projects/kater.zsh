load-kater() {
    if ! op whoami &>/dev/null; then
        eval $(op signin)
    fi
    
    echo "Loading Kater environment variables..."
    while IFS='=' read -r key value; do
        export "$key=$value"
    done < <(op item get Kater --vault Development --format json | jq -r '.fields[] | select(.type=="TEXT") | .label + "=" + .value')
    echo "Done! Kater environment variables are loaded."
}