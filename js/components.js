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

    // Injetar Botão Flutuante do WhatsApp
    const btnFlutuante = document.createElement('a');
    btnFlutuante.href = "https://wa.me/5571992126570";
    btnFlutuante.target = "_blank";
    btnFlutuante.rel = "noopener noreferrer";
    btnFlutuante.className = "btn-flutuante";
    btnFlutuante.setAttribute("aria-label", "Falar no WhatsApp");
    btnFlutuante.innerHTML = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>`;
    document.body.appendChild(btnFlutuante);
});
