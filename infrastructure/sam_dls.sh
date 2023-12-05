yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { eval "$@" || die "cannot $*"; }
#Run command based on action provided
case $1 in
    'build')
        
        yell "VueJs: Building application"
        vbuild="npm run build --prefix ./frontend/"
        try $vbuild
        ;;

    'package')
        #building and pushing docker image to ECR repository
        yell "SAM: Logging into Amazon ECR  Repository"
        slogin="aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 189731456380.dkr.ecr.us-east-1.amazonaws.com"
        try $slogin
        
        yell "SAM: Building the Docker image of ${config_ecr_repository_name}"
        sbuild="docker build -t sambhav-test-ecr:latest -f infrastructure/Dockerfile ."
        try $sbuild

        yell "SAM: Tagging Docker image with ${config_ecr_repository_name} ECR Repository"
        stag="docker tag sambhav-test-ecr:latest 189731456380.dkr.ecr.us-east-1.amazonaws.com/sambhav-test-ecr:latest"
        try $stag

        yell "SAM: Pushing the Docker image into ${config_ecr_repository_name} ECR Repository"
        spush="docker push 189731456380.dkr.ecr.us-east-1.amazonaws.com/sambhav-test-ecr:latest"
        try $spush
        ;;

esac