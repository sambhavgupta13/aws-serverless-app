yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { eval "$@" || die "cannot $*"; }
#Run command based on action provided
case $1 in
    'build')
        yell "SAM: Validate template"
        svalidate="sam validate --template-file infrastructure/template.yaml"
        try $svalidate

        yell "SAM:Building application"
        sbuild="sam build --template-file infrastructure/template.yaml"
        try $sbuild

        yell "VueJs: Building application"
        vbuild="npm run build --prefix ./frontend/"
        try $vbuild
        ;;

    'package')
        #building and pushing docker image to ECR repository
        # yell "SAM: Logging into Amazon ECR  Repository"
        # slogin="aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 189731456380.dkr.ecr.us-east-1.amazonaws.com"
        # try $slogin
        
        # yell "SAM: Building the Docker image of ${config_ecr_repository_name}"
        # sbuild="docker build -t sambhav-test-ecr:latest -f infrastructure/Dockerfile ."
        # try $sbuild

        # yell "SAM: Tagging Docker image with ${config_ecr_repository_name} ECR Repository"
        # stag="docker tag sambhav-test-ecr:latest 189731456380.dkr.ecr.us-east-1.amazonaws.com/sambhav-test-ecr:latest"
        # try $stag

        # yell "SAM: Pushing the Docker image into ${config_ecr_repository_name} ECR Repository"
        # spush="docker push 189731456380.dkr.ecr.us-east-1.amazonaws.com/sambhav-test-ecr:latest"
        # try $spush
        ;;

    'deploy')

        yell "Uploading static assets to bucket: 'static-assets-bucket-sambhav'"
        vdeploy="aws s3 sync ./frontend/dist s3://static-assets-bucket-sambhav --cache-control max-age=31536000"
        try $vdeploy

        # deploying SAM template
        yell "SAM: Deploying application"
        sdeploy="sam deploy \
        --s3-bucket sam-bucket-sambhav \
        --s3-prefix sam \
        --region us-east-1 \
        --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND CAPABILITY_NAMED_IAM \
        --no-fail-on-empty-changeset \
        --stack-name sambhav-resource-stack"
        try $sdeploy
    
        # yell "Updating ECS service task with latest image"
        # supdate="aws ecs update-service --cluster sambhav-test-cluster --service sambhav-test-service --force-new-deployment --region us-east-1"
        # try $supdate
        ;;

esac