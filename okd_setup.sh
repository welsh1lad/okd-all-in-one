#ansible-playbook -i hosts --vault-password-file ~/.vault_pass.txt  create_vm.yml
ansible-playbook -i hosts create_okd.yml -e target=10.60.10.27
