- name: Build test image
  docker_image:
    path: /docker/build_env/
    name: test_build
    tag: v0
    dockerfile: centos6-fresh/Dockerfile

---
- hosts: localhost
  connection: local

  tasks:
    - name: Ensure Docker image is built from the test Dockerfile.
      docker_image:
        name: test
        source: build
        build:
          path: test
        state: present

    - name: Ensure the test container is running.
      docker_container:
        image: test:latest
        name: test
        state: started

- name: pull an image
  docker_image:
    name: pacur/centos-7
    source: pull

- name: Tag and push to docker hub
  docker_image:
    name: pacur/centos-7:56
    repository: dcoppenhagan/myimage:7.56
    push: yes
    source: local

- name: Tag and push to local registry
  docker_image:
    # Image will be centos:7
    name: centos
    # Will be pushed to localhost:5000/centos:7
    repository: localhost:5000/centos
    tag: 7
    push: yes
    source: local

- name: Add tag latest to image
  docker_image:
    name: myimage:7.1.2
    repository: myimage:latest
    # As 'latest' usually already is present, we need to enable overwriting of existing tags:
    force_tag: yes
    source: local

- name: Remove image
  docker_image:
    state: absent
    name: registry.ansible.com/chouseknecht/sinatra
    tag: v1

- name: Build an image and push it to a private repo
  docker_image:
    build:
      path: ./sinatra
    name: registry.ansible.com/chouseknecht/sinatra
    tag: v1
    push: yes
    source: build

- name: Archive image
  docker_image:
    name: registry.ansible.com/chouseknecht/sinatra
    tag: v1
    archive_path: my_sinatra.tar
    source: local

- name: Load image from archive and push to a private registry
  docker_image:
    name: localhost:5000/myimages/sinatra
    tag: v1
    push: yes
    load_path: my_sinatra.tar
    source: load

- name: Build image and with build args
  docker_image:
    name: myimage
    build:
      path: /path/to/build/dir
      args:
        log_volume: /var/log/myapp
        listen_port: 8080
    source: build

- name: Build image using cache source
  docker_image:
    name: myimage:latest
    build:
      path: /path/to/build/dir
      # Use as cache source for building myimage
      cache_from:
        - nginx:latest
        - alpine:3.8
    source: build

- name: Git clone user-db
  git:
    repo: 'https://github.com/ryzhan/catalogue.git'
    dest: /opt/catalogue
    force: yes
  become: yes
  become_user: root
  become_method: sudo

- name: Build image catalogue-db
  docker_image:
    name: catalogue-db
    build:
      path: /opt/catalogue/docker/catalogue-db
      pull: yes
    source: build
  become: yes
  become_user: root
  become_method: sudo

- name: Run catalogue-db container
  docker_container:
    name: catalogue-db
    image: "catalogue-db"
    ports:
     - "3306:3306"
    restart_policy: always
    user: root
  become: yes

  - name: My application
  docker:
    name: web
    image: quay.io/smashwilson/minimal-sinatra:latest
    pull: always
    state: reloaded
    env:
      SOMEVAR: value
      SHH_SECRET: "{{ from_the_vault }}"
    link:
    - "database:database"
    
- hosts: all
  vars:
    hello: world
  tasks:
  - name: Ansible Basic Variable Example
    debug:
      msg: "{{ hello }}"

 hosts: all
  vars:
    hello:
      - World
      - Asia
      - South America
      - North America
      - Artic
      - Antartic
      - Oceania
      - Europe
      - Africa
  tasks:
  - name: Ansible List variable Example
    debug:
      msg: "{{ hello[2] }}"
  
- hosts: all
  vars:
    hello: [Asia, Americas, Artic, Antartic ,Oceania,Europe,Africa]
  tasks:
  - name: Ansible array variables example
    debug: 
      msg: "{{ item }}"
    with_items:
      - "{{ hello }}"
  
- hosts: all
  vars:
    python:
      Designer: 'Guido van Rosum'
      Developer: 'Python Software Foundation'
      OS: 'Cross-platform'
  tasks:
  - name: Ansible Dictionary Example
    debug:
      msg: "{{ python }}"
tasks:
  - name: Ansible Hash Example
    debug:
      msg: "{{python['Designer'] }}"
  - name: Ansible Find Example
    debug:
      msg: "{{python.Designer }}"

ars:
    python:{ Designer: 'Guido van Rossum', Developer: 'Python Software Foundation',OS: 'Cross-platform'}

- hosts: all
  vars:
    python:
      Designer: 'Guido van Rossum'
      Developer: 'Python Software Foundation'
      OS: 'Cross-platform'
  tasks:
  - name: Ansible Dictionary variable Example
    debug:
      msg: "Key is {{ item.key}} and value is {{item.value}}"
    with_dict: "{{ python }}"

- hosts: all
  vars:
    include_newlines_example: |
            The new line charaters
            will appear 

    ignore_newlines_example2: >
            The new line character will 
            be removed. Useful when editing 
            lines
  tasks:
  - name: Ansible varible multiple line Example
    debug:
      msg: "{{ include_newlines_example }}"

  - name: Ansible variables multiline Example
    debug:
      msg: "{{ ignore_newlines_example2 }}"
   - name: Create Container
      docker_container:
        name: "{{ name }}"
        image: "{{ image }}"
        ports:
          - "{{ src_port }}:{{ dest_port }}"
        volumes:
          - "{{ src_vol }}:{{ dest_vol }}"
        privileged: "{{ privileged }}"

- name: Remove the container
      docker_container:
        name: '{{ container_name }}'
        state: absent

        - name: "check status of existing container"
  shell: "docker ps -a -f name={{service_name}} -f ancestor={{service_full_image_name}} -f status=running --format='{''{.Image}''}'"
  register: service_container_status
  changed_when: false
  tags:
    - <service>

- name: "trigger restart if container is not running"
  command: "/bin/true"
  when: "service_container_status.stdout != service_full_image_name"
  notify:
    - "restart <service>"
  tags:
    - <service>

- name: "execute  handlers"
  meta: flush_handlers

  pipeline{

agent { node { label 'test' } }
options { skipDefaultCheckout() }

parameters {
    string(name: 'suiteFile', defaultValue: '', description: 'Suite File')
}
stages{

    stage('Initialize'){

        steps{

          echo "${params.suiteFile}"

        }
    }
 }
 pipeline {
    agent any
    parameters {
        string(name: 'PARAM1', description: 'Param 1?')
        string(name: 'PARAM2', description: 'Param 2?')
    }
    stages {
        stage('Example') {
            steps {
                echo "${params}"
                script {
                    def myparams = currentBuild.rawBuild.getAction(ParametersAction).getParameters()
                    build job: 'downstream-pipeline-with-params', parameters: myparams
                }    
            }
        }
    }
}
service = 'microservice'
echo "TESSSSSSSSTTT ${service}"
build(job: "'${service}'", parameters: [string(name: 'ENVNAME', value: 'uat')])
build(job: "${service}", parameters: [string(name: 'ENVNAME', value: 'uat')])

if (env.BRANCH_NAME == 'master') {
    build '../other-repo/master'
}
stage ('Starting ART job') {
    build job: 'RunArtInTest', parameters: [[$class: 'StringParameterValue', name: 'systemname', value: systemname]]
}
build job: 'your-job-name', 
    parameters: [
        string(name: 'passed_build_number_param', value: String.valueOf(BUILD_NUMBER)),
        string(name: 'complex_param', value: 'prefix-' + String.valueOf(BUILD_NUMBER))
    ]

