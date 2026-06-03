document.addEventListener("DOMContentLoaded", function() {
    // Carregar Header
    const headerPlaceholder = document.getElementById('header-placeholder');
    if (headerPlaceholder) {
        fetch('/components/header.html')
            .then(response => {
                if (!response.ok) throw new Error("Erro ao carregar o header");
                return response.text();
            })
            .then(data => {
                headerPlaceholder.innerHTML = data;
            })
            .catch(err => console.error("Falha ao injetar header:", err));
    }

    // Carregar Footer
    const footerPlaceholder = document.getElementById('footer-placeholder');
    if (footerPlaceholder) {
        fetch('/components/footer.html')
            .then(response => {
                if (!response.ok) throw new Error("Erro ao carregar o footer");
                return response.text();
            })
            .then(data => {
                footerPlaceholder.innerHTML = data;
            })
            .catch(err => console.error("Falha ao injetar footer:", err));
    }
});
