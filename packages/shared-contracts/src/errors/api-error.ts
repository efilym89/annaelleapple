import type { CommonErrorCode } from './common-error-code';

export interface FieldViolation {
  field: string;
  message: string;
}

export interface ApiErrorDetails {
  violations?: FieldViolation[];
  resourceId?: string;
  resourceType?: string;
}

export interface ApiErrorResponse {
  code: CommonErrorCode;
  message: string;
  traceId: string;
  timestamp: string;
  details?: ApiErrorDetails;
}
