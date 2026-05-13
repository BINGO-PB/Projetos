#!/usr/bin/env bash
# modules/docker.sh — containers, imagens, volumes, redes, daemon config

run_docker() {
    log INFO "[docker] coletando estado Docker"
    local d="${OUT_DIR}/docker"

    if ! command -v docker &>/dev/null; then
        log WARN "[docker] docker não encontrado — módulo ignorado"
        echo "# docker não disponível neste host" > "${d}/unavailable.txt"
        return
    fi

    run_cmd "${d}/docker-info.txt"     docker info
    run_cmd "${d}/docker-ps.txt"       docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
    run_cmd "${d}/docker-images.txt"   docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedSince}}"
    run_cmd "${d}/docker-volumes.txt"  docker volume ls
    run_cmd "${d}/docker-networks.txt" docker network ls
    run_cmd "${d}/docker-stats.txt"    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}"

    # Inspecionar cada container (configuração completa para recovery)
    local cname
    while read -r cname; do
        [[ -z "$cname" ]] && continue
        docker inspect "$cname" > "${d}/inspect-${cname}.json" 2>/dev/null || true
    done < <(docker ps -a --format "{{.Names}}" 2>/dev/null)

    # Salvar compose files encontrados
    local compose_dir
    for compose_dir in \
        /opt \
        /home \
        /srv \
        /docker \
        /var/lib/docker/compose \
        /root
    do
        [[ -d "$compose_dir" ]] || continue
        while read -r f; do
            [[ -n "$f" ]] || continue
            local safe
            safe="$(echo "$f" | tr '/' '_' | sed 's/^_//')"
            cp -a "$f" "${d}/compose_${safe}" 2>/dev/null || true
        done < <(
            find "$compose_dir" -maxdepth 4 \
                \( -name "docker-compose.yml" -o -name "docker-compose.yaml" -o -name "compose.yml" \) \
                2>/dev/null || true
        )
    done

    # Configuração do daemon
    copy_if_exists /etc/docker/daemon.json    "${d}/daemon.json"
    copy_if_exists /etc/docker               "${d}/etc-docker"

    log INFO "[docker] concluído → ${d}/"
}
