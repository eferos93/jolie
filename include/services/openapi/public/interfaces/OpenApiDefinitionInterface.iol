/*
The MIT License (MIT)
Copyright (c) 2016 Claudio Guidi <guidiclaudio@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

include "types/definition_types.iol"

type ExternalDocs: void {
    .url: string
    .description?: string
}

type Item: void {
    .type: string
    .format?: string
    .items*: Item
    .maximum: int
    .minimum: int
    /* NOT USED FOR Jolie purpouses
    .collectionFormat
    .default
    .exclusiceMaximum
    .exclusiceMinimum
    .maxLength
    .minLength
    .pattern
    .maxItems
    .minItems
    .uniqueItems
    .enum
    .multipleOf
  */
}

type OperationObject: void {
    .tags*: string
    .summary?: string
    .description?: string
    .externalDocs?: ExternalDocs
    .operationId: string
    .consumes*: string
    .produces*: string
    .parameters*: Parameter
    .responses*: Responses
}

type InBody: void {
    .schema_subType: SubType   // used when there are more parameters in the body
} | void {
    .schema_type: Type         // used when there is one single parameter in the body
} | void {
    .schema_ref?: string       // add a reference to a schema
}

type Parameter: void {
    .name: string
    .in: void {
        .in_body?:InBody
        .other?: string {               // "query", "header", "path", "formData"
            .type: Type
            .allowEmptyValue?: bool
        }
    }
    .required?: bool
    .description?: string
}

type Responses: void {
    .status: int 
    .schema?: Type
    .description: string
}


type GetOpenApiDefinitionRequest: void {
    .info: void {
        .title: string
        .description?: string
        .termsOfService?: string
        .contact?: void {
            .name?: string
            .url?: string
            .email?: string
        }
        .license?: void {
            .name: string
            .url: string
        }
        .version: string
    }
    .host: string
    .basePath: string
    .schemes*: string
    .consumes*: string
    .produces*: string
    .tags*: void {
        .name: string
        .description?: string
        .externalDocs?: ExternalDocs
    }
    .externalDocs?: ExternalDocs
    .paths*: string {
        .get?: OperationObject
        .post?: OperationObject
        .delete?: OperationObject
        .put?: OperationObject
        /* TODO
        .options?: OperationObject
        .head?: OperationObject
        .patch?: OperationObject
        .parameters?:
        */
    }
    .definitions*: TypeDefinition | FaultDefinitionForOpenAPI
    /* TODO
      .security?
      .securityDefinitions?
      .defintions?

    */
}

type FaultDefinitionForOpenAPI: void {
    .fault: TypeDefinition
    .name: string
}
type GetOpenApiDefinitionResponse: undefined

type GetJolieTypeFromOpenApiParametersRequest: void {
    .definition: undefined
    .name: string
}

type GetJolieTypeFromOpenApiDefinitionRequest: void {
    .name: string
    .definition: undefined
}

type GetJolieDefinitionFromOpenApiObjectRequest: void {
    .definition: undefined
    .indentation: int
}

type GetJolieDefinitionFromOpenApiArrayRequest: void {
    .definition: undefined
    .indentation: int
}

type GetJolieNativeTypeFromOpenApiNativeTypeRequest: void {
    .type: string | void
    .format?: string
}

interface OpenApiDefinitionInterface {
  RequestResponse:
      getOpenApiDefinition( GetOpenApiDefinitionRequest )( GetOpenApiDefinitionResponse ),
      getJolieTypeFromOpenApiDefinition( GetJolieTypeFromOpenApiDefinitionRequest )( string ),
      getJolieTypeFromOpenApiParameters( GetJolieTypeFromOpenApiParametersRequest )( string ),
      getJolieDefinitionFromOpenApiObject( GetJolieDefinitionFromOpenApiObjectRequest )( string )
        throws DefinitionError,
      getJolieDefinitionFromOpenApiArray( GetJolieDefinitionFromOpenApiArrayRequest )( string ),
      getJolieNativeTypeFromOpenApiNativeType( GetJolieNativeTypeFromOpenApiNativeTypeRequest )( string ),
      getReferenceName( string )( string )

}
