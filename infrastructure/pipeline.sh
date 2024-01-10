yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { eval "$@" || die "cannot $*"; }


#Run command based on action provided
case $1 in        

    'create')
        yell "Creating CloudFormation Stack"

        aws cloudformation create-stack \
          --capabilities CAPABILITY_IAM \
          --stack-name pipeline-cf-stack \
          --region us-east-1 \
          --template-body file://infrastructure/pipeline.yaml
        ;;

    'update')
        yell "Updating CloudFormation Stack"

        aws cloudformation update-stack \
          --capabilities CAPABILITY_IAM \
          --stack-name pipeline-cf-stack \
          --region us-east-1 \
          --parameters $stack_parameters \
          --template-body file://infrastructure/pipeline.yaml
        ;;
    
    'delete')
        yell "Deleting CloudFormation Stack"

        aws cloudformation delete-stack \
          --stack-name pipeline-cf-stack
        ;;
        
    *)
        die "Unsupported action: $1"
        ;;
esac